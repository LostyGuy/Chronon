example entry

python devlog/log.py "Schedule Tests Completed" `
-s passed `
-b "12/12 Passed" `
-t "tests,backend,schedule" `
-n "With this commit all of schedule module is completed;Along with this module following section we're changed: database scheme, error handling, introduction of devlog, seeding the database from .sql files instead of python code;Project name was changed from 'Uni-Schedule' to 'Chronon', which relates to time in many ways"

python devlog/log.py "Launch of Chronon Tester Reqruitment" `
-s feature `
-t "tests,backend,chronon" `
-n "From now on 'Uni-Schedule' - is Chronon.;At www.chronon.com.pl you can sign as a tester. Registration is open till the end of the 2026"