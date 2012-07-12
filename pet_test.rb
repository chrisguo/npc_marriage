# -*- coding: utf-8 -*-

# test Pet
require "./pet.rb"

xiao_zhang= Pet.new("xiaozhang")
xiao_zhang.sex=0

xiao_zhang_wife= Pet.new("xiaozhang_wife")
xiao_zhang_wife.sex=1

puts xiao_zhang.inspect
50.times{xiao_zhang.level_up}
puts xiao_zhang.inspect

30.times{xiao_zhang_wife.level_up}
puts xiao_zhang_wife.inspect

xiao_zhang_wife.level_up
if xiao_zhang.can_get_married?(xiao_zhang_wife) then
  xiao_zhang.marriage(xiao_zhang_wife)
  puts "hehe, marriaged."
else
  puts "Not marriaged, god!"
end
puts xiao_zhang.inspect
puts xiao_zhang_wife.inspect


xiao_zhang_wife1= Pet.new("xiaozhang_wife_1")

if(xiao_zhang.sex==1) then
xiao_zhang_wife1.sex=0
else
xiao_zhang_wife1.sex=1
end

51.times{xiao_zhang.level_up}

30.times{xiao_zhang_wife1.level_up}
puts xiao_zhang_wife1.inspect

if xiao_zhang.can_get_married?(xiao_zhang_wife1) then
  xiao_zhang.marriage(xiao_zhang_wife1)
  puts "hehe, marriaged."
else
  puts "Not marriaged, god!"
end
puts xiao_zhang.inspect


# --------------------------------------------------------------------------------
xiao_zhang_wife2= Pet.new("xiaozhang_wife_2")

if(xiao_zhang.sex==1) then
xiao_zhang_wife2.sex=0
else
xiao_zhang_wife2.sex=1
end

51.times{xiao_zhang.level_up}

30.times{xiao_zhang_wife2.level_up}
puts xiao_zhang_wife2.inspect

if xiao_zhang.can_get_married?(xiao_zhang_wife2) then
  xiao_zhang.marriage(xiao_zhang_wife2)
  puts "hehe, marriaged."
else
  puts "Not marriaged, god!"
end
puts xiao_zhang.inspect


# 上述代码验证，结婚系统及其支撑系统正确。
