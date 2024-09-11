describe 'database' do

    db_prompt = "DBPlus > "
    connection_close = "Closing connection..."
    executed_success = "Executed successfully."
    table_full = "Table full."
    string_too_long = "String is too long."
    id_negative = "ID must be positive."

    def run_script(commands)
        raw_output = nil
        IO.popen("./db", "r+") do |pipe|
            commands.each do |command|
                pipe.puts command
            end
            pipe.close_write

            sleep(0.5)

            # Read entire output
            raw_output = pipe.read
        end
        raw_output&.split("\n") || []
    end

    it 'inserts and select a single row' do
        results = run_script(["insert 1 user1 person1@example.com", "select", ".exit"])
        expect(results).to eq(["#{db_prompt + executed_success}", "#{db_prompt}(1, user1, person1@example.com)", "#{executed_success}", "#{db_prompt + connection_close}"])
    end
    
    it 'prints error message when table is full' do
        script = (1..1401).map do |i|
            "insert #{i} user#{i} person#{i}@example.com"
        end
        script << ".exit"
        results = run_script(script)
        expect(results[-2]).to eq("#{db_prompt}#{table_full}")
    end

    it 'allows inserting strings that are the maximum length' do
        long_username = "a"*32
        long_email = "a"*255
        script = [
            "insert 1 #{long_username} #{long_email}",
            "select",
            ".exit",
        ]
        result = run_script(script)
        expect(result).to eq(["#{db_prompt + executed_success}", "#{db_prompt}(1, #{long_username}, #{long_email})", "#{executed_success}", "#{db_prompt + connection_close}"])
    end

    it 'prints error message if strings are too long' do
        long_username = "a"*33
        long_email = "a"*256
        script = [
            "insert 1 #{long_username} #{long_email}",
            "select",
            ".exit",
        ]
        result = run_script(script)
        expect(result).to eq(["#{db_prompt + string_too_long}", "#{db_prompt + executed_success}", "#{db_prompt + connection_close}"])
    end

    it 'prints an error message if id is negative' do
        script = [
            "insert -1 cstack foo@bar.com",
            "select",
            ".exit",
        ]
        result = run_script(script)
        expect(result).to eq(["#{db_prompt + id_negative}", "#{db_prompt + executed_success}", "#{db_prompt + connection_close}"])
    end

    it 'keeps data after closing connection' do
        result1 = run_script([
            "insert 1 user1 person1@example.com",
            ".exit",
        ])
        expect(result1).to eq(["#{db_prompt + executed_success}", "#{db_prompt + connection_close}"])
        result2 = run_script([
            "select",
            ".exit",
        ])
        expect(result2).to eq(["#{db_prompt}(1, user1, person1@example.com)", "#{executed_success}", "#{db_prompt + connection_close}"])
    end
end