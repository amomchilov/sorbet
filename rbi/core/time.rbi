# typed: __STDLIB_INTERNAL

# [`Time`](https://docs.ruby-lang.org/en/2.7.0/Time.html) is an abstraction of
# dates and times. [`Time`](https://docs.ruby-lang.org/en/2.7.0/Time.html) is
# stored internally as the number of seconds with fraction since the *Epoch*,
# January 1, 1970 00:00 UTC. Also see the library module
# [`Date`](https://docs.ruby-lang.org/en/2.7.0/Date.html). The
# [`Time`](https://docs.ruby-lang.org/en/2.7.0/Time.html) class treats GMT
# (Greenwich Mean [`Time`](https://docs.ruby-lang.org/en/2.7.0/Time.html)) and
# UTC (Coordinated Universal
# [`Time`](https://docs.ruby-lang.org/en/2.7.0/Time.html)) as equivalent. GMT is
# the older way of referring to these baseline times but persists in the names
# of calls on POSIX systems.
#
# All times may have fraction. Be aware of this fact when comparing times with
# each other -- times that are apparently equal when displayed may be different
# when compared.
#
# Since Ruby 1.9.2, [`Time`](https://docs.ruby-lang.org/en/2.7.0/Time.html)
# implementation uses a signed 63 bit integer, Bignum or
# [`Rational`](https://docs.ruby-lang.org/en/2.7.0/Rational.html). The integer
# is a number of nanoseconds since the *Epoch* which can represent 1823-11-12 to
# 2116-02-20. When Bignum or
# [`Rational`](https://docs.ruby-lang.org/en/2.7.0/Rational.html) is used
# (before 1823, after 2116, under nanosecond),
# [`Time`](https://docs.ruby-lang.org/en/2.7.0/Time.html) works slower as when
# integer is used.
#
# # Examples
#
# All of these examples were done using the EST timezone which is GMT-5.
#
# ## Creating a new [`Time`](https://docs.ruby-lang.org/en/2.7.0/Time.html) instance
#
# You can create a new instance of
# [`Time`](https://docs.ruby-lang.org/en/2.7.0/Time.html) with
# [`Time::new`](https://docs.ruby-lang.org/en/2.7.0/Time.html#method-c-new).
# This will use the current system time.
# [`Time::now`](https://docs.ruby-lang.org/en/2.7.0/Time.html#method-c-now) is
# an alias for this. You can also pass parts of the time to
# [`Time::new`](https://docs.ruby-lang.org/en/2.7.0/Time.html#method-c-new) such
# as year, month, minute, etc. When you want to construct a time this way you
# must pass at least a year. If you pass the year with nothing else time will
# default to January 1 of that year at 00:00:00 with the current system
# timezone. Here are some examples:
#
# ```ruby
# Time.new(2002)         #=> 2002-01-01 00:00:00 -0500
# Time.new(2002, 10)     #=> 2002-10-01 00:00:00 -0500
# Time.new(2002, 10, 31) #=> 2002-10-31 00:00:00 -0500
# ```
#
# You can pass a UTC offset:
#
# ```ruby
# Time.new(2002, 10, 31, 2, 2, 2, "+02:00") #=> 2002-10-31 02:02:02 +0200
# ```
#
# Or a timezone object:
#
# ```ruby
# tz = timezone("Europe/Athens") # Eastern European Time, UTC+2
# Time.new(2002, 10, 31, 2, 2, 2, tz) #=> 2002-10-31 02:02:02 +0200
# ```
#
# You can also use
# [`Time::gm`](https://docs.ruby-lang.org/en/2.7.0/Time.html#method-c-gm),
# [`Time::local`](https://docs.ruby-lang.org/en/2.7.0/Time.html#method-c-local)
# and [`Time::utc`](https://docs.ruby-lang.org/en/2.7.0/Time.html#method-c-utc)
# to infer GMT, local and UTC timezones instead of using the current system
# setting.
#
# You can also create a new time using
# [`Time::at`](https://docs.ruby-lang.org/en/2.7.0/Time.html#method-c-at) which
# takes the number of seconds (or fraction of seconds) since the [Unix
# Epoch](http://en.wikipedia.org/wiki/Unix_time).
#
# ```ruby
# Time.at(628232400) #=> 1989-11-28 00:00:00 -0500
# ```
#
# ## Working with an instance of [`Time`](https://docs.ruby-lang.org/en/2.7.0/Time.html)
#
# Once you have an instance of
# [`Time`](https://docs.ruby-lang.org/en/2.7.0/Time.html) there is a multitude
# of things you can do with it. Below are some examples. For all of the
# following examples, we will work on the assumption that you have done the
# following:
#
# ```ruby
# t = Time.new(1993, 02, 24, 12, 0, 0, "+09:00")
# ```
#
# Was that a monday?
#
# ```ruby
# t.monday? #=> false
# ```
#
# What year was that again?
#
# ```ruby
# t.year #=> 1993
# ```
#
# Was it daylight savings at the time?
#
# ```ruby
# t.dst? #=> false
# ```
#
# What's the day a year later?
#
# ```ruby
# t + (60*60*24*365) #=> 1994-02-24 12:00:00 +0900
# ```
#
# How many seconds was that since the Unix Epoch?
#
# ```ruby
# t.to_i #=> 730522800
# ```
#
# You can also do standard functions like compare two times.
#
# ```ruby
# t1 = Time.new(2010)
# t2 = Time.new(2011)
#
# t1 == t2 #=> false
# t1 == t1 #=> true
# t1 <  t2 #=> true
# t1 >  t2 #=> false
#
# Time.new(2010,10,31).between?(t1, t2) #=> true
# ```
#
# ## Timezone argument
#
# A timezone argument must have `local_to_utc` and `utc_to_local` methods, and
# may have `name`, `abbr`, and `dst?` methods.
#
# The `local_to_utc` method should convert a Time-like object from the timezone
# to UTC, and `utc_to_local` is the opposite. The result also should be a
# [`Time`](https://docs.ruby-lang.org/en/2.7.0/Time.html) or Time-like object
# (not necessary to be the same class). The
# [`zone`](https://docs.ruby-lang.org/en/2.7.0/Time.html#method-i-zone) of the
# result is just ignored. Time-like argument to these methods is similar to a
# [`Time`](https://docs.ruby-lang.org/en/2.7.0/Time.html) object in UTC without
# sub-second; it has attribute readers for the parts, e.g.
# [`year`](https://docs.ruby-lang.org/en/2.7.0/Time.html#method-i-year),
# [`month`](https://docs.ruby-lang.org/en/2.7.0/Time.html#method-i-month), and
# so on, and epoch time readers,
# [`to_i`](https://docs.ruby-lang.org/en/2.7.0/Time.html#method-i-to_i). The
# sub-second attributes are fixed as 0, and
# [`utc_offset`](https://docs.ruby-lang.org/en/2.7.0/Time.html#method-i-utc_offset),
# [`zone`](https://docs.ruby-lang.org/en/2.7.0/Time.html#method-i-zone),
# [`isdst`](https://docs.ruby-lang.org/en/2.7.0/Time.html#method-i-isdst), and
# their aliases are same as a
# [`Time`](https://docs.ruby-lang.org/en/2.7.0/Time.html) object in UTC. Also
# [`to_time`](https://docs.ruby-lang.org/en/2.7.0/Time.html#method-i-to_time),
# [`+`](https://docs.ruby-lang.org/en/2.7.0/Time.html#method-i-2B), and
# [`-`](https://docs.ruby-lang.org/en/2.7.0/Time.html#method-i-2D) methods are
# defined.
#
# The `name` method is used for marshaling. If this method is not defined on a
# timezone object, [`Time`](https://docs.ruby-lang.org/en/2.7.0/Time.html)
# objects using that timezone object can not be dumped by
# [`Marshal`](https://docs.ruby-lang.org/en/2.7.0/Marshal.html).
#
# The `abbr` method is used by '%Z' in
# [`strftime`](https://docs.ruby-lang.org/en/2.7.0/Time.html#method-i-strftime).
#
# The `dst?` method is called with a `Time` value and should return whether the
# `Time` value is in daylight savings time in the zone.
#
# ### Auto conversion to Timezone
#
# At loading marshaled data, a timezone name will be converted to a timezone
# object by `find_timezone` class method, if the method is defined.
#
# Similarly, that class method will be called when a timezone argument does not
# have the necessary methods mentioned above.
class Time < Object
  include Comparable

  RFC2822_DAY_NAME = T.let(T.unsafe(nil), T::Array[T.untyped])
  RFC2822_MONTH_NAME = T.let(T.unsafe(nil), T::Array[T.untyped])

  # Creates a new [`Time`](https://docs.ruby-lang.org/en/2.7.0/Time.html) object
  # with the value given by `time`, the given number of `seconds_with_frac`, or
  # `seconds` and `microseconds_with_frac` since the Epoch. `seconds_with_frac`
  # and `microseconds_with_frac` can be an
  # [`Integer`](https://docs.ruby-lang.org/en/2.7.0/Integer.html),
  # [`Float`](https://docs.ruby-lang.org/en/2.7.0/Float.html),
  # [`Rational`](https://docs.ruby-lang.org/en/2.7.0/Rational.html), or other
  # [`Numeric`](https://docs.ruby-lang.org/en/2.7.0/Numeric.html). non-portable
  # feature allows the offset to be negative on some systems.
  #
  # If `in` argument is given, the result is in that timezone or UTC offset, or
  # if a numeric argument is given, the result is in local time.
  #
  # ```ruby
  # Time.at(0)                                #=> 1969-12-31 18:00:00 -0600
  # Time.at(Time.at(0))                       #=> 1969-12-31 18:00:00 -0600
  # Time.at(946702800)                        #=> 1999-12-31 23:00:00 -0600
  # Time.at(-284061600)                       #=> 1960-12-31 00:00:00 -0600
  # Time.at(946684800.2).usec                 #=> 200000
  # Time.at(946684800, 123456.789).nsec       #=> 123456789
  # Time.at(946684800, 123456789, :nsec).nsec #=> 123456789
  # ```
  sig do
    params(
        seconds: T.any(Time, Numeric)
    )
    .returns(Time)
  end
  sig do
    params(
        seconds: Numeric,
        microseconds_with_frac: Numeric,
    )
    .returns(Time)
  end
  sig do
    params(
        seconds: Numeric,
        microseconds_with_frac: Numeric,
        fractional_precision: Symbol
    )
    .returns(Time)
  end
  def self.at(seconds, microseconds_with_frac=T.unsafe(nil), fractional_precision=T.unsafe(nil)); end

  # Creates a [`Time`](https://docs.ruby-lang.org/en/2.7.0/Time.html) object
  # based on given values, interpreted as UTC (GMT). The year must be specified.
  # Other values default to the minimum value for that field (and may be `nil`
  # or omitted). Months may be specified by numbers from 1 to 12, or by the
  # three-letter [`English`](https://docs.ruby-lang.org/en/2.7.0/English.html)
  # month names. Hours are specified on a 24-hour clock (0..23). Raises an
  # [`ArgumentError`](https://docs.ruby-lang.org/en/2.7.0/ArgumentError.html) if
  # any values are out of range. Will also accept ten arguments in the order
  # output by
  # [`Time#to_a`](https://docs.ruby-lang.org/en/2.7.0/Time.html#method-i-to_a).
  #
  # `sec_with_frac` and `usec_with_frac` can have a fractional part.
  #
  # ```ruby
  # Time.utc(2000,"jan",1,20,15,1)  #=> 2000-01-01 20:15:01 UTC
  # Time.gm(2000,"jan",1,20,15,1)   #=> 2000-01-01 20:15:01 UTC
  # ```
  sig do
    params(
        year: Integer,
        month: T.any(Integer, String),
        day: Integer,
        hour: Integer,
        min: Integer,
        sec: Numeric,
        usec_with_frac: Numeric,
    )
    .returns(Time)
  end
  def self.gm(year, month=T.unsafe(nil), day=T.unsafe(nil), hour=T.unsafe(nil), min=T.unsafe(nil), sec=T.unsafe(nil), usec_with_frac=T.unsafe(nil)); end

  # Same as
  # [`Time::gm`](https://docs.ruby-lang.org/en/2.7.0/Time.html#method-c-gm), but
  # interprets the values in the local time zone.
  #
  # ```ruby
  # Time.local(2000,"jan",1,20,15,1)   #=> 2000-01-01 20:15:01 -0600
  # ```
  sig do
    params(
        year: Integer,
        month: T.any(Integer, String),
        day: Integer,
        hour: Integer,
        min: Integer,
        sec: Numeric,
        usec_with_frac: Numeric,
    )
    .returns(Time)
  end
  def self.local(year, month=T.unsafe(nil), day=T.unsafe(nil), hour=T.unsafe(nil), min=T.unsafe(nil), sec=T.unsafe(nil), usec_with_frac=T.unsafe(nil)); end

  # Creates a new [`Time`](https://docs.ruby-lang.org/en/2.7.0/Time.html) object
  # for the current time. This is same as
  # [`Time.new`](https://docs.ruby-lang.org/en/2.7.0/Time.html#method-c-new)
  # without arguments.
  #
  # ```ruby
  # Time.now            #=> 2009-06-24 12:39:54 +0900
  # ```
  sig {returns(Time)}
  def self.now(); end

  # Creates a [`Time`](https://docs.ruby-lang.org/en/2.7.0/Time.html) object
  # based on given values, interpreted as UTC (GMT). The year must be specified.
  # Other values default to the minimum value for that field (and may be `nil`
  # or omitted). Months may be specified by numbers from 1 to 12, or by the
  # three-letter [`English`](https://docs.ruby-lang.org/en/2.7.0/English.html)
  # month names. Hours are specified on a 24-hour clock (0..23). Raises an
  # [`ArgumentError`](https://docs.ruby-lang.org/en/2.7.0/ArgumentError.html) if
  # any values are out of range. Will also accept ten arguments in the order
  # output by
  # [`Time#to_a`](https://docs.ruby-lang.org/en/2.7.0/Time.html#method-i-to_a).
  #
  # `sec_with_frac` and `usec_with_frac` can have a fractional part.
  #
  # ```ruby
  # Time.utc(2000,"jan",1,20,15,1)  #=> 2000-01-01 20:15:01 UTC
  # Time.gm(2000,"jan",1,20,15,1)   #=> 2000-01-01 20:15:01 UTC
  # ```
  sig do
    params(
        year: Integer,
        month: T.any(Integer, String),
        day: Integer,
        hour: Integer,
        min: Integer,
        sec: Numeric,
        usec_with_frac: Numeric,
    )
    .returns(Time)
  end
  def self.utc(year, month=T.unsafe(nil), day=T.unsafe(nil), hour=T.unsafe(nil), min=T.unsafe(nil), sec=T.unsafe(nil), usec_with_frac=T.unsafe(nil)); end

  # Addition --- Adds some number of seconds (possibly fractional) to *time* and
  # returns that value as a new
  # [`Time`](https://docs.ruby-lang.org/en/2.7.0/Time.html) object.
  #
  # ```ruby
  # t = Time.now         #=> 2007-11-19 08:22:21 -0600
  # t + (60 * 60 * 24)   #=> 2007-11-20 08:22:21 -0600
  # ```
  sig do
    params(
        arg0: Numeric,
    )
    .returns(Time)
  end
  def +(arg0); end

  # Difference --- Returns a difference in seconds as a
  # [`Float`](https://docs.ruby-lang.org/en/2.7.0/Float.html) between *time* and
  # `other_time`, or subtracts the given number of seconds in `numeric` from
  # *time*.
  #
  # ```ruby
  # t = Time.now       #=> 2007-11-19 08:23:10 -0600
  # t2 = t + 2592000   #=> 2007-12-19 08:23:10 -0600
  # t2 - t             #=> 2592000.0
  # t2 - 2592000       #=> 2007-11-19 08:23:10 -0600
  # ```
  sig do
    params(
        arg0: Time,
    )
    .returns(Float)
  end
  sig do
    params(
        arg0: Numeric,
    )
    .returns(Time)
  end
  def -(arg0); end

  sig do
    params(
        arg0: Time,
    )
    .returns(T::Boolean)
  end
  def <(arg0); end

  sig do
    params(
        arg0: Time,
    )
    .returns(T::Boolean)
  end
  def <=(arg0); end

  # Comparison---Compares `time` with `other_time`.
  #
  # -1, 0, +1 or nil depending on whether `time` is less  than, equal to, or
  # greater than `other_time`.
  #
  # `nil` is returned if the two values are incomparable.
  #
  # ```ruby
  # t = Time.now       #=> 2007-11-19 08:12:12 -0600
  # t2 = t + 2592000   #=> 2007-12-19 08:12:12 -0600
  # t <=> t2           #=> -1
  # t2 <=> t           #=> 1
  #
  # t = Time.now       #=> 2007-11-19 08:13:38 -0600
  # t2 = t + 0.1       #=> 2007-11-19 08:13:38 -0600
  # t.nsec             #=> 98222999
  # t2.nsec            #=> 198222999
  # t <=> t2           #=> -1
  # t2 <=> t           #=> 1
  # t <=> t            #=> 0
  # ```
  sig do
    params(
        other: Object,
    )
    .returns(T.nilable(Integer))
  end
  def <=>(other); end

  sig do
    params(
        arg0: Time,
    )
    .returns(T::Boolean)
  end
  def >(arg0); end

  sig do
    params(
        arg0: Time,
    )
    .returns(T::Boolean)
  end
  def >=(arg0); end

  # Returns a canonical string representation of *time*.
  #
  # ```ruby
  # Time.now.asctime   #=> "Wed Apr  9 08:56:03 2003"
  # Time.now.ctime     #=> "Wed Apr  9 08:56:03 2003"
  # ```
  sig {returns(String)}
  def asctime(); end

  # Ceils sub seconds to a given precision in decimal digits (0 digits by
  # default). It returns a new
  # [`Time`](https://docs.ruby-lang.org/en/2.7.0/Time.html) object. `ndigits`
  # should be zero or a positive integer.
  #
  # ```ruby
  # require 'time'
  #
  # t = Time.utc(2010,3,30, 5,43,25.0123456789r)
  # t.iso8601(10)          #=> "2010-03-30T05:43:25.0123456789Z"
  # t.ceil.iso8601(10)     #=> "2010-03-30T05:43:26.0000000000Z"
  # t.ceil(0).iso8601(10)  #=> "2010-03-30T05:43:26.0000000000Z"
  # t.ceil(1).iso8601(10)  #=> "2010-03-30T05:43:25.1000000000Z"
  # t.ceil(2).iso8601(10)  #=> "2010-03-30T05:43:25.0200000000Z"
  # t.ceil(3).iso8601(10)  #=> "2010-03-30T05:43:25.0130000000Z"
  # t.ceil(4).iso8601(10)  #=> "2010-03-30T05:43:25.0124000000Z"
  #
  # t = Time.utc(1999,12,31, 23,59,59)
  # (t + 0.4).ceil.iso8601(3)    #=> "2000-01-01T00:00:00.000Z"
  # (t + 0.9).ceil.iso8601(3)    #=> "2000-01-01T00:00:00.000Z"
  # (t + 1.4).ceil.iso8601(3)    #=> "2000-01-01T00:00:01.000Z"
  # (t + 1.9).ceil.iso8601(3)    #=> "2000-01-01T00:00:01.000Z"
  #
  # t = Time.utc(1999,12,31, 23,59,59)
  # (t + 0.123456789).ceil(4).iso8601(6)  #=> "1999-12-31T23:59:59.123500Z"
  # ```
  sig {returns(Time)}
  sig do
    params(
      ndigits: Integer
    )
    .returns(Time)
  end
  def ceil(ndigits=0); end

  # Returns a canonical string representation of *time*.
  #
  # ```ruby
  # Time.now.asctime   #=> "Wed Apr  9 08:56:03 2003"
  # Time.now.ctime     #=> "Wed Apr  9 08:56:03 2003"
  # ```
  sig {returns(String)}
  def ctime(); end

  # Returns the day of the month (1..n) for *time*.
  #
  # ```ruby
  # t = Time.now   #=> 2007-11-19 08:27:03 -0600
  # t.day          #=> 19
  # t.mday         #=> 19
  # ```
  sig {returns(Integer)}
  def day(); end

  # Returns `true` if *time* occurs during Daylight Saving
  # [`Time`](https://docs.ruby-lang.org/en/2.7.0/Time.html) in its time zone.
  #
  # ```ruby
  # # CST6CDT:
  #   Time.local(2000, 1, 1).zone    #=> "CST"
  #   Time.local(2000, 1, 1).isdst   #=> false
  #   Time.local(2000, 1, 1).dst?    #=> false
  #   Time.local(2000, 7, 1).zone    #=> "CDT"
  #   Time.local(2000, 7, 1).isdst   #=> true
  #   Time.local(2000, 7, 1).dst?    #=> true
  #
  # # Asia/Tokyo:
  #   Time.local(2000, 1, 1).zone    #=> "JST"
  #   Time.local(2000, 1, 1).isdst   #=> false
  #   Time.local(2000, 1, 1).dst?    #=> false
  #   Time.local(2000, 7, 1).zone    #=> "JST"
  #   Time.local(2000, 7, 1).isdst   #=> false
  #   Time.local(2000, 7, 1).dst?    #=> false
  # ```
  sig {returns(T::Boolean)}
  def dst?(); end

  # Returns `true` if *time* and `other_time` are both
  # [`Time`](https://docs.ruby-lang.org/en/2.7.0/Time.html) objects with the
  # same seconds and fractional seconds.
  sig do
    params(
        arg0: BasicObject,
    )
    .returns(T::Boolean)
  end
  def eql?(arg0); end

  # Floors sub seconds to a given precision in decimal digits (0 digits by
  # default). It returns a new
  # [`Time`](https://docs.ruby-lang.org/en/2.7.0/Time.html) object. `ndigits`
  # should be zero or a positive integer.
  #
  # ```ruby
  # require 'time'
  #
  # t = Time.utc(2010,3,30, 5,43,25.123456789r)
  # t.iso8601(10)           #=> "2010-03-30T05:43:25.1234567890Z"
  # t.floor.iso8601(10)     #=> "2010-03-30T05:43:25.0000000000Z"
  # t.floor(0).iso8601(10)  #=> "2010-03-30T05:43:25.0000000000Z"
  # t.floor(1).iso8601(10)  #=> "2010-03-30T05:43:25.1000000000Z"
  # t.floor(2).iso8601(10)  #=> "2010-03-30T05:43:25.1200000000Z"
  # t.floor(3).iso8601(10)  #=> "2010-03-30T05:43:25.1230000000Z"
  # t.floor(4).iso8601(10)  #=> "2010-03-30T05:43:25.1234000000Z"
  #
  # t = Time.utc(1999,12,31, 23,59,59)
  # (t + 0.4).floor.iso8601(3)    #=> "1999-12-31T23:59:59.000Z"
  # (t + 0.9).floor.iso8601(3)    #=> "1999-12-31T23:59:59.000Z"
  # (t + 1.4).floor.iso8601(3)    #=> "2000-01-01T00:00:00.000Z"
  # (t + 1.9).floor.iso8601(3)    #=> "2000-01-01T00:00:00.000Z"
  #
  # t = Time.utc(1999,12,31, 23,59,59)
  # (t + 0.123456789).floor(4).iso8601(6)  #=> "1999-12-31T23:59:59.123400Z"
  # ```
  sig {returns(Time)}
  sig do
    params(
      ndigits: Integer
    )
    .returns(Time)
  end
  def floor(ndigits=0); end

  # Returns `true` if *time* represents Friday.
  #
  # ```ruby
  # t = Time.local(1987, 12, 18)     #=> 1987-12-18 00:00:00 -0600
  # t.friday?                        #=> true
  # ```
  sig {returns(T::Boolean)}
  def friday?(); end

  # Returns a new [`Time`](https://docs.ruby-lang.org/en/2.7.0/Time.html) object
  # representing *time* in UTC.
  #
  # ```ruby
  # t = Time.local(2000,1,1,20,15,1)   #=> 2000-01-01 20:15:01 -0600
  # t.gmt?                             #=> false
  # y = t.getgm                        #=> 2000-01-02 02:15:01 UTC
  # y.gmt?                             #=> true
  # t == y                             #=> true
  # ```
  sig {returns(Time)}
  def getgm(); end

  # Returns a new [`Time`](https://docs.ruby-lang.org/en/2.7.0/Time.html) object
  # representing *time* in local time (using the local time zone in effect for
  # this process).
  #
  # If `utc_offset` is given, it is used instead of the local time. `utc_offset`
  # can be given as a human-readable string (eg. `"+09:00"`) or as a number of
  # seconds (eg. `32400`).
  #
  # ```ruby
  # t = Time.utc(2000,1,1,20,15,1)  #=> 2000-01-01 20:15:01 UTC
  # t.utc?                          #=> true
  #
  # l = t.getlocal                  #=> 2000-01-01 14:15:01 -0600
  # l.utc?                          #=> false
  # t == l                          #=> true
  #
  # j = t.getlocal("+09:00")        #=> 2000-01-02 05:15:01 +0900
  # j.utc?                          #=> false
  # t == j                          #=> true
  #
  # k = t.getlocal(9*60*60)         #=> 2000-01-02 05:15:01 +0900
  # k.utc?                          #=> false
  # t == k                          #=> true
  # ```
  sig do
    params(
        utc_offset: T.any(Integer, String),
    )
    .returns(Time)
  end
  def getlocal(utc_offset=T.unsafe(nil)); end

  # Returns a new [`Time`](https://docs.ruby-lang.org/en/2.7.0/Time.html) object
  # representing *time* in UTC.
  #
  # ```ruby
  # t = Time.local(2000,1,1,20,15,1)   #=> 2000-01-01 20:15:01 -0600
  # t.gmt?                             #=> false
  # y = t.getgm                        #=> 2000-01-02 02:15:01 UTC
  # y.gmt?                             #=> true
  # t == y                             #=> true
  # ```
  sig {returns(Time)}
  def getutc(); end

  # Returns `true` if *time* represents a time in UTC (GMT).
  #
  # ```ruby
  # t = Time.now                        #=> 2007-11-19 08:15:23 -0600
  # t.utc?                              #=> false
  # t = Time.gm(2000,"jan",1,20,15,1)   #=> 2000-01-01 20:15:01 UTC
  # t.utc?                              #=> true
  #
  # t = Time.now                        #=> 2007-11-19 08:16:03 -0600
  # t.gmt?                              #=> false
  # t = Time.gm(2000,1,1,20,15,1)       #=> 2000-01-01 20:15:01 UTC
  # t.gmt?                              #=> true
  # ```
  sig {returns(T::Boolean)}
  def gmt?(); end

  # Returns the offset in seconds between the timezone of *time* and UTC.
  #
  # ```ruby
  # t = Time.gm(2000,1,1,20,15,1)   #=> 2000-01-01 20:15:01 UTC
  # t.gmt_offset                    #=> 0
  # l = t.getlocal                  #=> 2000-01-01 14:15:01 -0600
  # l.gmt_offset                    #=> -21600
  # ```
  sig {returns(Integer)}
  def gmt_offset(); end

  # Converts *time* to UTC (GMT), modifying the receiver.
  #
  # ```ruby
  # t = Time.now   #=> 2007-11-19 08:18:31 -0600
  # t.gmt?         #=> false
  # t.gmtime       #=> 2007-11-19 14:18:31 UTC
  # t.gmt?         #=> true
  #
  # t = Time.now   #=> 2007-11-19 08:18:51 -0600
  # t.utc?         #=> false
  # t.utc          #=> 2007-11-19 14:18:51 UTC
  # t.utc?         #=> true
  # ```
  sig {returns(Time)}
  def gmtime(); end

  # Returns a hash code for this
  # [`Time`](https://docs.ruby-lang.org/en/2.7.0/Time.html) object.
  #
  # See also
  # [`Object#hash`](https://docs.ruby-lang.org/en/2.7.0/Object.html#method-i-hash).
  sig {returns(Integer)}
  def hash(); end

  # Returns the hour of the day (0..23) for *time*.
  #
  # ```ruby
  # t = Time.now   #=> 2007-11-19 08:26:20 -0600
  # t.hour         #=> 8
  # ```
  sig {returns(Integer)}
  def hour(); end

  sig do
    params(
      year: T.any(Integer, String),
      month: T.any(Integer, String),
      day: T.any(Integer, String),
      hour: T.any(Integer, String),
      min: T.any(Integer, String),
      sec: T.any(Numeric, String),
      tz: T.any(Numeric, String),
    )
    .void
  end
  def initialize(year=T.unsafe(nil), month=T.unsafe(nil), day=T.unsafe(nil), hour=T.unsafe(nil), min=T.unsafe(nil), sec=T.unsafe(nil), tz=T.unsafe(nil)); end

  # Returns a detailed string representing *time*. Unlike
  # [`to_s`](https://docs.ruby-lang.org/en/2.7.0/Time.html#method-i-to_s),
  # preserves nanoseconds in the representation for easier debugging.
  #
  # ```ruby
  # t = Time.now
  # t.inspect                             #=> "2012-11-10 18:16:12.261257655 +0100"
  # t.strftime "%Y-%m-%d %H:%M:%S.%N %z"  #=> "2012-11-10 18:16:12.261257655 +0100"
  #
  # t.utc.inspect                          #=> "2012-11-10 17:16:12.261257655 UTC"
  # t.strftime "%Y-%m-%d %H:%M:%S.%N UTC"  #=> "2012-11-10 17:16:12.261257655 UTC"
  # ```
  sig {returns(String)}
  def inspect(); end

  # Returns `true` if *time* occurs during Daylight Saving
  # [`Time`](https://docs.ruby-lang.org/en/2.7.0/Time.html) in its time zone.
  #
  # ```ruby
  # # CST6CDT:
  #   Time.local(2000, 1, 1).zone    #=> "CST"
  #   Time.local(2000, 1, 1).isdst   #=> false
  #   Time.local(2000, 1, 1).dst?    #=> false
  #   Time.local(2000, 7, 1).zone    #=> "CDT"
  #   Time.local(2000, 7, 1).isdst   #=> true
  #   Time.local(2000, 7, 1).dst?    #=> true
  #
  # # Asia/Tokyo:
  #   Time.local(2000, 1, 1).zone    #=> "JST"
  #   Time.local(2000, 1, 1).isdst   #=> false
  #   Time.local(2000, 1, 1).dst?    #=> false
  #   Time.local(2000, 7, 1).zone    #=> "JST"
  #   Time.local(2000, 7, 1).isdst   #=> false
  #   Time.local(2000, 7, 1).dst?    #=> false
  # ```
  sig {returns(T::Boolean)}
  def isdst(); end

  # Converts *time* to local time (using the local time zone in effect at the
  # creation time of *time*) modifying the receiver.
  #
  # If `utc_offset` is given, it is used instead of the local time.
  #
  # ```ruby
  # t = Time.utc(2000, "jan", 1, 20, 15, 1) #=> 2000-01-01 20:15:01 UTC
  # t.utc?                                  #=> true
  #
  # t.localtime                             #=> 2000-01-01 14:15:01 -0600
  # t.utc?                                  #=> false
  #
  # t.localtime("+09:00")                   #=> 2000-01-02 05:15:01 +0900
  # t.utc?                                  #=> false
  # ```
  #
  # If `utc_offset` is not given and *time* is local time, just returns the
  # receiver.
  sig do
    params(
        utc_offset: String,
    )
    .returns(Time)
  end
  def localtime(utc_offset=T.unsafe(nil)); end

  # Returns the day of the month (1..n) for *time*.
  #
  # ```ruby
  # t = Time.now   #=> 2007-11-19 08:27:03 -0600
  # t.day          #=> 19
  # t.mday         #=> 19
  # ```
  sig {returns(Integer)}
  def mday(); end

  # Returns the minute of the hour (0..59) for *time*.
  #
  # ```ruby
  # t = Time.now   #=> 2007-11-19 08:25:51 -0600
  # t.min          #=> 25
  # ```
  sig {returns(Integer)}
  def min(); end

  # Returns the month of the year (1..12) for *time*.
  #
  # ```ruby
  # t = Time.now   #=> 2007-11-19 08:27:30 -0600
  # t.mon          #=> 11
  # t.month        #=> 11
  # ```
  sig {returns(Integer)}
  def mon(); end

  # Returns `true` if *time* represents Monday.
  #
  # ```ruby
  # t = Time.local(2003, 8, 4)       #=> 2003-08-04 00:00:00 -0500
  # t.monday?                        #=> true
  # ```
  sig {returns(T::Boolean)}
  def monday?(); end

  # Returns the number of nanoseconds for *time*.
  #
  # ```ruby
  # t = Time.now        #=> 2007-11-17 15:18:03 +0900
  # "%10.9f" % t.to_f   #=> "1195280283.536151409"
  # t.nsec              #=> 536151406
  # ```
  #
  # The lowest digits of
  # [`to_f`](https://docs.ruby-lang.org/en/2.7.0/Time.html#method-i-to_f) and
  # [`nsec`](https://docs.ruby-lang.org/en/2.7.0/Time.html#method-i-nsec) are
  # different because IEEE 754 double is not accurate enough to represent the
  # exact number of nanoseconds since the Epoch.
  #
  # The more accurate value is returned by
  # [`nsec`](https://docs.ruby-lang.org/en/2.7.0/Time.html#method-i-nsec).
  sig {returns(Integer)}
  def nsec(); end

  # Rounds sub seconds to a given precision in decimal digits (0 digits by
  # default). It returns a new
  # [`Time`](https://docs.ruby-lang.org/en/2.7.0/Time.html) object. `ndigits`
  # should be zero or a positive integer.
  #
  # ```ruby
  # require 'time'
  #
  # t = Time.utc(2010,3,30, 5,43,25.123456789r)
  # t.iso8601(10)           #=> "2010-03-30T05:43:25.1234567890Z"
  # t.round.iso8601(10)     #=> "2010-03-30T05:43:25.0000000000Z"
  # t.round(0).iso8601(10)  #=> "2010-03-30T05:43:25.0000000000Z"
  # t.round(1).iso8601(10)  #=> "2010-03-30T05:43:25.1000000000Z"
  # t.round(2).iso8601(10)  #=> "2010-03-30T05:43:25.1200000000Z"
  # t.round(3).iso8601(10)  #=> "2010-03-30T05:43:25.1230000000Z"
  # t.round(4).iso8601(10)  #=> "2010-03-30T05:43:25.1235000000Z"
  #
  # t = Time.utc(1999,12,31, 23,59,59)
  # (t + 0.4).round.iso8601(3)    #=> "1999-12-31T23:59:59.000Z"
  # (t + 0.49).round.iso8601(3)   #=> "1999-12-31T23:59:59.000Z"
  # (t + 0.5).round.iso8601(3)    #=> "2000-01-01T00:00:00.000Z"
  # (t + 1.4).round.iso8601(3)    #=> "2000-01-01T00:00:00.000Z"
  # (t + 1.49).round.iso8601(3)   #=> "2000-01-01T00:00:00.000Z"
  # (t + 1.5).round.iso8601(3)    #=> "2000-01-01T00:00:01.000Z"
  #
  # t = Time.utc(1999,12,31, 23,59,59)
  # (t + 0.123456789).round(4).iso8601(6)  #=> "1999-12-31T23:59:59.123500Z"
  # ```
  sig do
    params(
        arg0: Integer,
    )
    .returns(Time)
  end
  def round(arg0 = 0); end

  # Returns `true` if *time* represents Saturday.
  #
  # ```ruby
  # t = Time.local(2006, 6, 10)      #=> 2006-06-10 00:00:00 -0500
  # t.saturday?                      #=> true
  # ```
  sig {returns(T::Boolean)}
  def saturday?(); end

  # Returns the second of the minute (0..60) for *time*.
  #
  # **Note:** Seconds range from zero to 60 to allow the system to inject leap
  # seconds. See http://en.wikipedia.org/wiki/Leap\_second for further details.
  #
  # ```ruby
  # t = Time.now   #=> 2007-11-19 08:25:02 -0600
  # t.sec          #=> 2
  # ```
  sig {returns(Integer)}
  def sec(); end

  # Formats *time* according to the directives in the given format string.
  #
  # The directives begin with a percent (%) character. Any text not listed as a
  # directive will be passed through to the output string.
  #
  # The directive consists of a percent (%) character, zero or more flags,
  # optional minimum field width, optional modifier and a conversion specifier
  # as follows:
  #
  # ```
  # %<flags><width><modifier><conversion>
  # ```
  #
  # Flags:
  #
  # ```
  # -  don't pad a numerical output
  # _  use spaces for padding
  # 0  use zeros for padding
  # ^  upcase the result string
  # #  change case
  # :  use colons for %z
  # ```
  #
  # The minimum field width specifies the minimum width.
  #
  # The modifiers are "E" and "O". They are ignored.
  #
  # Format directives:
  #
  # ```
  # Date (Year, Month, Day):
  #   %Y - Year with century if provided, will pad result at least 4 digits.
  #           -0001, 0000, 1995, 2009, 14292, etc.
  #   %C - year / 100 (rounded down such as 20 in 2009)
  #   %y - year % 100 (00..99)
  #
  #   %m - Month of the year, zero-padded (01..12)
  #           %_m  blank-padded ( 1..12)
  #           %-m  no-padded (1..12)
  #   %B - The full month name (``January'')
  #           %^B  uppercased (``JANUARY'')
  #   %b - The abbreviated month name (``Jan'')
  #           %^b  uppercased (``JAN'')
  #   %h - Equivalent to %b
  #
  #   %d - Day of the month, zero-padded (01..31)
  #           %-d  no-padded (1..31)
  #   %e - Day of the month, blank-padded ( 1..31)
  #
  #   %j - Day of the year (001..366)
  #
  # Time (Hour, Minute, Second, Subsecond):
  #   %H - Hour of the day, 24-hour clock, zero-padded (00..23)
  #   %k - Hour of the day, 24-hour clock, blank-padded ( 0..23)
  #   %I - Hour of the day, 12-hour clock, zero-padded (01..12)
  #   %l - Hour of the day, 12-hour clock, blank-padded ( 1..12)
  #   %P - Meridian indicator, lowercase (``am'' or ``pm'')
  #   %p - Meridian indicator, uppercase (``AM'' or ``PM'')
  #
  #   %M - Minute of the hour (00..59)
  #
  #   %S - Second of the minute (00..60)
  #
  #   %L - Millisecond of the second (000..999)
  #        The digits under millisecond are truncated to not produce 1000.
  #   %N - Fractional seconds digits, default is 9 digits (nanosecond)
  #           %3N  millisecond (3 digits)
  #           %6N  microsecond (6 digits)
  #           %9N  nanosecond (9 digits)
  #           %12N picosecond (12 digits)
  #           %15N femtosecond (15 digits)
  #           %18N attosecond (18 digits)
  #           %21N zeptosecond (21 digits)
  #           %24N yoctosecond (24 digits)
  #        The digits under the specified length are truncated to avoid
  #        carry up.
  #
  # Time zone:
  #   %z - Time zone as hour and minute offset from UTC (e.g. +0900)
  #           %:z - hour and minute offset from UTC with a colon (e.g. +09:00)
  #           %::z - hour, minute and second offset from UTC (e.g. +09:00:00)
  #   %Z - Abbreviated time zone name or similar information.  (OS dependent)
  #
  # Weekday:
  #   %A - The full weekday name (``Sunday'')
  #           %^A  uppercased (``SUNDAY'')
  #   %a - The abbreviated name (``Sun'')
  #           %^a  uppercased (``SUN'')
  #   %u - Day of the week (Monday is 1, 1..7)
  #   %w - Day of the week (Sunday is 0, 0..6)
  #
  # ISO 8601 week-based year and week number:
  # The first week of YYYY starts with a Monday and includes YYYY-01-04.
  # The days in the year before the first week are in the last week of
  # the previous year.
  #   %G - The week-based year
  #   %g - The last 2 digits of the week-based year (00..99)
  #   %V - Week number of the week-based year (01..53)
  #
  # Week number:
  # The first week of YYYY that starts with a Sunday or Monday (according to %U
  # or %W). The days in the year before the first week are in week 0.
  #   %U - Week number of the year. The week starts with Sunday. (00..53)
  #   %W - Week number of the year. The week starts with Monday. (00..53)
  #
  # Seconds since the Epoch:
  #   %s - Number of seconds since 1970-01-01 00:00:00 UTC.
  #
  # Literal string:
  #   %n - Newline character (\n)
  #   %t - Tab character (\t)
  #   %% - Literal ``%'' character
  #
  # Combination:
  #   %c - date and time (%a %b %e %T %Y)
  #   %D - Date (%m/%d/%y)
  #   %F - The ISO 8601 date format (%Y-%m-%d)
  #   %v - VMS date (%e-%^b-%4Y)
  #   %x - Same as %D
  #   %X - Same as %T
  #   %r - 12-hour time (%I:%M:%S %p)
  #   %R - 24-hour time (%H:%M)
  #   %T - 24-hour time (%H:%M:%S)
  # ```
  #
  # This method is similar to strftime() function defined in ISO C and POSIX.
  #
  # While all directives are locale independent since Ruby 1.9, %Z is platform
  # dependent. So, the result may differ even if the same format string is used
  # in other systems such as C.
  #
  # %z is recommended over %Z. %Z doesn't identify the timezone. For example,
  # "CST" is used at America/Chicago (-06:00), America/Havana (-05:00),
  # Asia/Harbin (+08:00), Australia/Darwin (+09:30) and Australia/Adelaide
  # (+10:30). Also, %Z is highly dependent on the operating system. For example,
  # it may generate a non ASCII string on Japanese Windows, i.e. the result can
  # be different to "JST". So the numeric time zone offset, %z, is recommended.
  #
  # Examples:
  #
  # ```ruby
  # t = Time.new(2007,11,19,8,37,48,"-06:00") #=> 2007-11-19 08:37:48 -0600
  # t.strftime("Printed on %m/%d/%Y")         #=> "Printed on 11/19/2007"
  # t.strftime("at %I:%M %p")                 #=> "at 08:37 AM"
  # ```
  #
  # Various ISO 8601 formats:
  #
  # ```
  # %Y%m%d           => 20071119                  Calendar date (basic)
  # %F               => 2007-11-19                Calendar date (extended)
  # %Y-%m            => 2007-11                   Calendar date, reduced accuracy, specific month
  # %Y               => 2007                      Calendar date, reduced accuracy, specific year
  # %C               => 20                        Calendar date, reduced accuracy, specific century
  # %Y%j             => 2007323                   Ordinal date (basic)
  # %Y-%j            => 2007-323                  Ordinal date (extended)
  # %GW%V%u          => 2007W471                  Week date (basic)
  # %G-W%V-%u        => 2007-W47-1                Week date (extended)
  # %GW%V            => 2007W47                   Week date, reduced accuracy, specific week (basic)
  # %G-W%V           => 2007-W47                  Week date, reduced accuracy, specific week (extended)
  # %H%M%S           => 083748                    Local time (basic)
  # %T               => 08:37:48                  Local time (extended)
  # %H%M             => 0837                      Local time, reduced accuracy, specific minute (basic)
  # %H:%M            => 08:37                     Local time, reduced accuracy, specific minute (extended)
  # %H               => 08                        Local time, reduced accuracy, specific hour
  # %H%M%S,%L        => 083748,000                Local time with decimal fraction, comma as decimal sign (basic)
  # %T,%L            => 08:37:48,000              Local time with decimal fraction, comma as decimal sign (extended)
  # %H%M%S.%L        => 083748.000                Local time with decimal fraction, full stop as decimal sign (basic)
  # %T.%L            => 08:37:48.000              Local time with decimal fraction, full stop as decimal sign (extended)
  # %H%M%S%z         => 083748-0600               Local time and the difference from UTC (basic)
  # %T%:z            => 08:37:48-06:00            Local time and the difference from UTC (extended)
  # %Y%m%dT%H%M%S%z  => 20071119T083748-0600      Date and time of day for calendar date (basic)
  # %FT%T%:z         => 2007-11-19T08:37:48-06:00 Date and time of day for calendar date (extended)
  # %Y%jT%H%M%S%z    => 2007323T083748-0600       Date and time of day for ordinal date (basic)
  # %Y-%jT%T%:z      => 2007-323T08:37:48-06:00   Date and time of day for ordinal date (extended)
  # %GW%V%uT%H%M%S%z => 2007W471T083748-0600      Date and time of day for week date (basic)
  # %G-W%V-%uT%T%:z  => 2007-W47-1T08:37:48-06:00 Date and time of day for week date (extended)
  # %Y%m%dT%H%M      => 20071119T0837             Calendar date and local time (basic)
  # %FT%R            => 2007-11-19T08:37          Calendar date and local time (extended)
  # %Y%jT%H%MZ       => 2007323T0837Z             Ordinal date and UTC of day (basic)
  # %Y-%jT%RZ        => 2007-323T08:37Z           Ordinal date and UTC of day (extended)
  # %GW%V%uT%H%M%z   => 2007W471T0837-0600        Week date and local time and difference from UTC (basic)
  # %G-W%V-%uT%R%:z  => 2007-W47-1T08:37-06:00    Week date and local time and difference from UTC (extended)
  # ```
  sig do
    params(
        arg0: String,
    )
    .returns(String)
  end
  def strftime(arg0); end

  # Returns the fraction for *time*.
  #
  # The return value can be a rational number.
  #
  # ```ruby
  # t = Time.now        #=> 2009-03-26 22:33:12 +0900
  # "%10.9f" % t.to_f   #=> "1238074392.940563917"
  # t.subsec            #=> (94056401/100000000)
  # ```
  #
  # The lowest digits of
  # [`to_f`](https://docs.ruby-lang.org/en/2.7.0/Time.html#method-i-to_f) and
  # [`subsec`](https://docs.ruby-lang.org/en/2.7.0/Time.html#method-i-subsec)
  # are different because IEEE 754 double is not accurate enough to represent
  # the rational number.
  #
  # The more accurate value is returned by
  # [`subsec`](https://docs.ruby-lang.org/en/2.7.0/Time.html#method-i-subsec).
  sig {returns(Numeric)}
  def subsec(); end

  # Returns `true` if *time* represents Sunday.
  #
  # ```ruby
  # t = Time.local(1990, 4, 1)       #=> 1990-04-01 00:00:00 -0600
  # t.sunday?                        #=> true
  # ```
  sig {returns(T::Boolean)}
  def sunday?(); end

  # Returns `true` if *time* represents Thursday.
  #
  # ```ruby
  # t = Time.local(1995, 12, 21)     #=> 1995-12-21 00:00:00 -0600
  # t.thursday?                      #=> true
  # ```
  sig {returns(T::Boolean)}
  def thursday?(); end

  # Returns a ten-element *array* of values for *time*:
  #
  # ```ruby
  # [sec, min, hour, day, month, year, wday, yday, isdst, zone]
  # ```
  #
  # See the individual methods for an explanation of the valid ranges of each
  # value. The ten elements can be passed directly to
  # [`Time::utc`](https://docs.ruby-lang.org/en/2.7.0/Time.html#method-c-utc) or
  # [`Time::local`](https://docs.ruby-lang.org/en/2.7.0/Time.html#method-c-local)
  # to create a new [`Time`](https://docs.ruby-lang.org/en/2.7.0/Time.html)
  # object.
  #
  # ```ruby
  # t = Time.now     #=> 2007-11-19 08:36:01 -0600
  # now = t.to_a     #=> [1, 36, 8, 19, 11, 2007, 1, 323, false, "CST"]
  # ```
  sig {returns([Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, T::Boolean, String])}
  def to_a(); end

  # Returns the value of *time* as a floating point number of seconds since the
  # Epoch.
  #
  # ```ruby
  # t = Time.now
  # "%10.5f" % t.to_f   #=> "1270968744.77658"
  # t.to_i              #=> 1270968744
  # ```
  #
  # Note that IEEE 754 double is not accurate enough to represent the exact
  # number of nanoseconds since the Epoch.
  sig {returns(Float)}
  def to_f(); end

  # Returns the value of *time* as an integer number of seconds since the Epoch.
  #
  # ```ruby
  # t = Time.now
  # "%10.5f" % t.to_f   #=> "1270968656.89607"
  # t.to_i              #=> 1270968656
  # ```
  sig {returns(Integer)}
  def to_i(); end

  # Returns the value of *time* as a rational number of seconds since the Epoch.
  #
  # ```ruby
  # t = Time.now
  # t.to_r            #=> (1270968792716287611/1000000000)
  # ```
  #
  # This methods is intended to be used to get an accurate value representing
  # the nanoseconds since the Epoch. You can use this method to convert *time*
  # to another Epoch.
  sig {returns(Rational)}
  def to_r(); end

  # Returns a string representing *time*. Equivalent to calling
  # [`strftime`](https://docs.ruby-lang.org/en/2.7.0/Time.html#method-i-strftime)
  # with the appropriate format string.
  #
  # ```ruby
  # t = Time.now
  # t.to_s                              #=> "2012-11-10 18:16:12 +0100"
  # t.strftime "%Y-%m-%d %H:%M:%S %z"   #=> "2012-11-10 18:16:12 +0100"
  #
  # t.utc.to_s                          #=> "2012-11-10 17:16:12 UTC"
  # t.strftime "%Y-%m-%d %H:%M:%S UTC"  #=> "2012-11-10 17:16:12 UTC"
  # ```
  sig {returns(String)}
  def to_s(); end

  # Returns `true` if *time* represents Tuesday.
  #
  # ```ruby
  # t = Time.local(1991, 2, 19)      #=> 1991-02-19 00:00:00 -0600
  # t.tuesday?                       #=> true
  # ```
  sig {returns(T::Boolean)}
  def tuesday?(); end

  # Returns the number of nanoseconds for *time*.
  #
  # ```ruby
  # t = Time.now        #=> 2007-11-17 15:18:03 +0900
  # "%10.9f" % t.to_f   #=> "1195280283.536151409"
  # t.nsec              #=> 536151406
  # ```
  #
  # The lowest digits of
  # [`to_f`](https://docs.ruby-lang.org/en/2.7.0/Time.html#method-i-to_f) and
  # [`nsec`](https://docs.ruby-lang.org/en/2.7.0/Time.html#method-i-nsec) are
  # different because IEEE 754 double is not accurate enough to represent the
  # exact number of nanoseconds since the Epoch.
  #
  # The more accurate value is returned by
  # [`nsec`](https://docs.ruby-lang.org/en/2.7.0/Time.html#method-i-nsec).
  sig {returns(Numeric)}
  def tv_nsec(); end

  # Returns the value of *time* as an integer number of seconds since the Epoch.
  #
  # ```ruby
  # t = Time.now
  # "%10.5f" % t.to_f   #=> "1270968656.89607"
  # t.to_i              #=> 1270968656
  # ```
  sig {returns(Numeric)}
  def tv_sec(); end

  # Returns the number of microseconds for *time*.
  #
  # ```ruby
  # t = Time.now        #=> 2007-11-19 08:03:26 -0600
  # "%10.6f" % t.to_f   #=> "1195481006.775195"
  # t.usec              #=> 775195
  # ```
  sig {returns(Numeric)}
  def tv_usec(); end

  # Returns the number of microseconds for *time*.
  #
  # ```ruby
  # t = Time.now        #=> 2007-11-19 08:03:26 -0600
  # "%10.6f" % t.to_f   #=> "1195481006.775195"
  # t.usec              #=> 775195
  # ```
  sig {returns(Numeric)}
  def usec(); end

  # Converts *time* to UTC (GMT), modifying the receiver.
  #
  # ```ruby
  # t = Time.now   #=> 2007-11-19 08:18:31 -0600
  # t.gmt?         #=> false
  # t.gmtime       #=> 2007-11-19 14:18:31 UTC
  # t.gmt?         #=> true
  #
  # t = Time.now   #=> 2007-11-19 08:18:51 -0600
  # t.utc?         #=> false
  # t.utc          #=> 2007-11-19 14:18:51 UTC
  # t.utc?         #=> true
  # ```
  sig {returns(Time)}
  def utc(); end

  # Returns `true` if *time* represents a time in UTC (GMT).
  #
  # ```ruby
  # t = Time.now                        #=> 2007-11-19 08:15:23 -0600
  # t.utc?                              #=> false
  # t = Time.gm(2000,"jan",1,20,15,1)   #=> 2000-01-01 20:15:01 UTC
  # t.utc?                              #=> true
  #
  # t = Time.now                        #=> 2007-11-19 08:16:03 -0600
  # t.gmt?                              #=> false
  # t = Time.gm(2000,1,1,20,15,1)       #=> 2000-01-01 20:15:01 UTC
  # t.gmt?                              #=> true
  # ```
  sig {returns(T::Boolean)}
  def utc?(); end

  # Returns the offset in seconds between the timezone of *time* and UTC.
  #
  # ```ruby
  # t = Time.gm(2000,1,1,20,15,1)   #=> 2000-01-01 20:15:01 UTC
  # t.gmt_offset                    #=> 0
  # l = t.getlocal                  #=> 2000-01-01 14:15:01 -0600
  # l.gmt_offset                    #=> -21600
  # ```
  sig {returns(Integer)}
  def utc_offset(); end

  # Returns an integer representing the day of the week, 0..6, with Sunday == 0.
  #
  # ```ruby
  # t = Time.now   #=> 2007-11-20 02:35:35 -0600
  # t.wday         #=> 2
  # t.sunday?      #=> false
  # t.monday?      #=> false
  # t.tuesday?     #=> true
  # t.wednesday?   #=> false
  # t.thursday?    #=> false
  # t.friday?      #=> false
  # t.saturday?    #=> false
  # ```
  sig {returns(Integer)}
  def wday(); end

  # Returns `true` if *time* represents Wednesday.
  #
  # ```ruby
  # t = Time.local(1993, 2, 24)      #=> 1993-02-24 00:00:00 -0600
  # t.wednesday?                     #=> true
  # ```
  sig {returns(T::Boolean)}
  def wednesday?(); end

  # Returns an integer representing the day of the year, 1..366.
  #
  # ```ruby
  # t = Time.now   #=> 2007-11-19 08:32:31 -0600
  # t.yday         #=> 323
  # ```
  sig {returns(Integer)}
  def yday(); end

  # Returns the year for *time* (including the century).
  #
  # ```ruby
  # t = Time.now   #=> 2007-11-19 08:27:51 -0600
  # t.year         #=> 2007
  # ```
  sig {returns(Integer)}
  def year(); end

  # Returns the name of the time zone used for *time*. As of Ruby 1.8, returns
  # "UTC" rather than "GMT" for UTC times.
  #
  # ```ruby
  # t = Time.gm(2000, "jan", 1, 20, 15, 1)
  # t.zone   #=> "UTC"
  # t = Time.local(2000, "jan", 1, 20, 15, 1)
  # t.zone   #=> "CST"
  # ```
  sig {returns(String)}
  def zone(); end

  # Same as
  # [`Time::gm`](https://docs.ruby-lang.org/en/2.7.0/Time.html#method-c-gm), but
  # interprets the values in the local time zone.
  #
  # ```ruby
  # Time.local(2000,"jan",1,20,15,1)   #=> 2000-01-01 20:15:01 -0600
  # ```
  sig do
    params(
        year: Integer,
        month: T.any(Integer, String),
        day: Integer,
        hour: Integer,
        min: Integer,
        sec: Numeric,
        usec_with_frac: Numeric,
    )
    .returns(Time)
  end
  def self.mktime(year, month=T.unsafe(nil), day=T.unsafe(nil), hour=T.unsafe(nil), min=T.unsafe(nil), sec=T.unsafe(nil), usec_with_frac=T.unsafe(nil)); end

  # Returns the offset in seconds between the timezone of *time* and UTC.
  #
  # ```ruby
  # t = Time.gm(2000,1,1,20,15,1)   #=> 2000-01-01 20:15:01 UTC
  # t.gmt_offset                    #=> 0
  # l = t.getlocal                  #=> 2000-01-01 14:15:01 -0600
  # l.gmt_offset                    #=> -21600
  # ```
  sig {returns(Integer)}
  def gmtoff(); end

  # Returns the month of the year (1..12) for *time*.
  #
  # ```ruby
  # t = Time.now   #=> 2007-11-19 08:27:30 -0600
  # t.mon          #=> 11
  # t.month        #=> 11
  # ```
  sig {returns(Integer)}
  def month(); end
end
