describe 'database' do

    before do
        'rm -rf ../test.db'
    end

    db_prompt = "DBPlus > "
    connection_close = "Closing connection..."
    executed_success = "Executed successfully."
    table_full = "Table full."
    string_too_long = "String is too long."
    id_negative = "ID must be positive."
    duplicate_key = "Duplicate key."

    def check_db_existence()
        if File.exist?("test.db")
            File.delete("test.db")  

            puts "\nDB removed.\n"
        else
            puts "DB not existing.\n"
        end
    end

    def recreate_exe()
        if File.exist?("db")
            File.delete("db")
            IO.popen("make")
        end  
    end

    def run_script(commands)
        raw_output = nil
        IO.popen("./db test.db", "r+") do |pipe|
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
        check_db_existence()
        results = run_script(["insert 1 user1 person1@example.com", "select", ".exit"])
        expect(results).to eq(["#{db_prompt + executed_success}", "#{db_prompt}(1, user1, person1@example.com)", "#{executed_success}", "#{db_prompt + connection_close}"])
    end
    
    it 'prints error message when table is full' do
        check_db_existence()
        script = (1..1401).map do |i|
            "insert #{i} user#{i} person#{i}@example.com"
        end
        script << ".exit"
        results = run_script(script)
        expect(results[-2]).to eq("#{db_prompt}#{table_full}")
    end
    
    it 'allows inserting strings that are the maximum length' do
        check_db_existence()
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
        check_db_existence()
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
        check_db_existence()
        script = [
            "insert -1 cstack foo@bar.com",
            "select",
            ".exit",
        ]
        result = run_script(script)
        expect(result).to eq(["#{db_prompt + id_negative}", "#{db_prompt + executed_success}", "#{db_prompt + connection_close}"])
    end
                
    it 'keeps data after closing connection' do
        check_db_existence()
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

    it 'prints constants' do 
            script = [
                ".constants",
                ".exit",
            ]
            result = run_script(script)

            expect(result).to eq([
                "#{db_prompt}Constants:",
                "ROW_SIZE: 293",
                "COMMON_NODE_HEADER_SIZE: 6",
                "LEAF_NODE_HEADER_SIZE: 10",
                "LEAF_NODE_CELL_SIZE: 297",
                "LEAF_NODE_SPACE_FOR_CELLS: 4086",
                "LEAF_NODE_MAX_CELLS: 13",
                "#{db_prompt + connection_close}",
            ])
    end

    it 'allows printing out the structure of a one-node btree' do
        check_db_existence()
        script = [3, 1, 2].map do |i|
          "insert #{i} user#{i} person#{i}@example.com"
        end
        script << ".btree"
        script << ".exit"
        result = run_script(script)

        expect(result).to eq([
            "#{db_prompt + executed_success}",
            "#{db_prompt}Inserting key: 1 at position: 0",
            "#{executed_success}",
            "#{db_prompt}Inserting key: 2 at position: 1",
            "#{executed_success}",
            "#{db_prompt}Tree:",
            "Leaf (size 3)",
            "  - 0 : 1",
            "  - 1 : 2",
            "  - 2 : 3",
            "#{db_prompt + connection_close}",
        ])
    end

    it 'prints an error message if there is a duplicate id' do
        check_db_existence()
        script = [
            "insert 1 user1 person1@example.com",
            "insert 1 user1 person1@example.com",
            "select",
            ".exit",
        ]
        result = run_script(script)
        expect(result).to eq([
            "#{db_prompt + executed_success}",
            "#{db_prompt + duplicate_key}",
            "#{db_prompt}(1, user1, person1@example.com)",
            "#{executed_success}",
            "#{db_prompt + connection_close}"
        ])
    end
end