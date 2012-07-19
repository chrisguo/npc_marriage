# -*- coding: utf-8 -*-

# test Pet
# 没有结婚戒指情况下的结婚测试。
require "./pet.rb"

xiao_zhang= Pet.new("张飞")
xiao_zhang.sex=0

xiao_zhang_wife= Pet.new("小龙女")
xiao_zhang_wife.sex=1

puts xiao_zhang.inspect
50.times{xiao_zhang.level_up}
puts xiao_zhang.inspect
puts ""

40.times{xiao_zhang_wife.level_up}
puts xiao_zhang_wife.inspect
puts ""

xiao_zhang_wife.level_up
if xiao_zhang.can_get_married?(xiao_zhang_wife) then
  xiao_zhang.marriage(xiao_zhang_wife,ring=false)
        puts "哇，结婚了！新伙伴诞生了！革命事业我来扛，一代更比一代强。"
 
else
  puts "Not marriaged, god!"
end
puts xiao_zhang.inspect
puts ""

xiao_zhang_wife1= Pet.new("迎春")

if(xiao_zhang.sex==1) then
xiao_zhang_wife1.sex=0
else
xiao_zhang_wife1.sex=1
end

51.times{xiao_zhang.level_up}

40.times{xiao_zhang_wife1.level_up}
puts xiao_zhang_wife1.inspect

if xiao_zhang.can_get_married?(xiao_zhang_wife1) then
  xiao_zhang.marriage(xiao_zhang_wife1,ring=false)
  puts "哇，结婚了！新伙伴诞生了！革命事业我来扛，一代更比一代强。"
else
  puts "Not marriaged, god!"
end
puts xiao_zhang.inspect
puts ""

# --------------------------------------------------------------------------------
xiao_zhang_wife2= Pet.new("黛玉")

if(xiao_zhang.sex==1) then
xiao_zhang_wife2.sex=0
else
xiao_zhang_wife2.sex=1
end

51.times{xiao_zhang.level_up}

40.times{xiao_zhang_wife2.level_up}
puts xiao_zhang_wife2.inspect

if xiao_zhang.can_get_married?(xiao_zhang_wife2) then
  xiao_zhang.marriage(xiao_zhang_wife2,ring=false)
        puts "哇，结婚了！新伙伴诞生了！革命事业我来扛，一代更比一代强。"
else
  puts "Not marriaged, god!"
end
puts xiao_zhang.inspect
puts ""
# 结婚100次。
100.times{
     # 先升级主将到50级别。
     xiao_zhang.set_level(1)
     
     loop do 
       if xiao_zhang.level >= 50
          break
       else
           xiao_zhang.level_up
       end
     end
     # 造一个副将。
     xiao_zhang_wife2= Pet.new("黛玉")
     # 先升级副将到40级。
     40.times{xiao_zhang_wife2.level_up}
     # 测试能否结婚。
     if xiao_zhang.can_get_married?(xiao_zhang_wife2) then
       xiao_zhang.marriage(xiao_zhang_wife2,ring=false)
       
       puts "哇，结婚了！新伙伴诞生了！革命事业我来扛，一代更比一代强。"
     else
       puts "Not marriaged, god!"
     end
     puts xiao_zhang.inspect
    puts ""


}



# 结婚500次。
500.times{
     # 先升级主将到50级别。
     xiao_zhang.set_level(1)
     
     loop do 
       if xiao_zhang.level >= 50
          break
       else
           xiao_zhang.level_up
       end
     end


     # 造一个副将。
     xiao_zhang_wife2= Pet.new("黛玉")
     # 先升级副将到40级。
     40.times{xiao_zhang_wife2.level_up}
     # 测试能否结婚。
     if xiao_zhang.can_get_married?(xiao_zhang_wife2) then
       xiao_zhang.marriage(xiao_zhang_wife2,ring=false)
       puts "哇，结婚了！新伙伴诞生了！革命事业我来扛，一代更比一代强。"
     else
       puts "Not marriaged, god!"
     end
      puts xiao_zhang.inspect
puts ""
}


xiao_zhang.write_version_star_record

puts "Done!"



# 上述代码验证，结婚系统及其支撑系统正确。
