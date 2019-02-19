#!/usr/bin/expect
spawn passwd foo
expect "password:"
send "Xcv15kl\r"
expect "Retype new password:"
send "Xcv15kl\r"
interact