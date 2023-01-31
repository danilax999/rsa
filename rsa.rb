#!/usr/bin/env ruby

module RSA
  class << self
    def prime?(x)
      if x == 2
        true
      elsif x < 2 || x.even?
        false
      else
        (3..).step(2)
             .take_while { |i| i * i <= x }
             .all? { |i| x % i != 0 }
      end
    end

    def find_prime(x) = x.downto(1).find { |i| prime? i }

    def egcd(a, b)
      x0, x1, y0, y1 = 0, 1, 1, 0

      while a != 0
        (q, a), b = b.divmod(a), a
        y0, y1 = y1, y0 - q * y1
        x0, x1 = x1, x0 - q * x1
      end

      [b, x0, y0]
    end

    def mod_inverse(a, m)
      res = egcd(a, m)[1]
      res += m while res.negative?
      res
    end

    def gen_keys(range)
      p = find_prime rand(range)
      q = find_prime rand(range)
      n = p * q

      phi = (p - 1) * (q - 1)
      e = find_prime phi
      d = mod_inverse e, phi

      [[e, n], [d, n]]
    end

    def encrypt(x, (e, n)) = x**e % n

    def decrypt(x, (d, n)) = x**d % n
  end
end

if __FILE__ == $PROGRAM_NAME
  print 'Enter a number: '

  x = gets.to_i
  public_key, private_key = RSA.gen_keys(20..100)
  encrypted = RSA.encrypt x, public_key
  decrypted = RSA.decrypt encrypted, private_key

  puts <<~EOF

    Public key:  #{public_key}
    Private key: #{private_key}
    Encrypted:   #{encrypted}
    Decrypted:   #{decrypted}
  EOF
end
