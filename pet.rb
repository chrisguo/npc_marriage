# -*- coding: utf-8 -*-
=begin

伙伴结婚系统。
规则都在代码之中了。


游戏有结婚系统，结婚能创造出更好的武将。

基础

1、武将有星级。其中1星武将智力，武力，防御的属性成长总和大于0小于10，2星武将的总成长是大于等于10小于20，依次类推。

2、武将有基本属性。

3、结婚原理：主将+副将=孩子

孩子的基本属性等于主将基本属性+（副将基本属性-主将基本属性）/2.如主将武力是100，副将是150，那么结婚后的就是125.

孩子的成长属性：主将成长属性+副将的最高的那项成长属性的随机值（如果使用结婚戒指，据说可以+副将最高属性全值）

举例

主将属性，50级2星

武力：200

防御：100

智力：0

武力成长：9

防御成长：8

智力成长：2

副将属性，20级1星

武力：300

防御：200

智力：100

武力成长：5

防御成长：2

智力成长：2

如果未使用结婚戒指，孩子的属性：

武力：250

防御：150

智力：50

武力成长：9-14（如果使用戒指据说是14）

防御成长：8

智力成长：2

这样引出另外个问题，如何选主将？？？

这个列子看出来，这个孩子在出生后，只要攻击成长属性>10,总属性>20了！那么就成为3星武将了。

慢慢的，这个武将将到达10星，10星后，就需要至少3星以上的武将做为副将了，这样找副将就比较困难。

所以我们在选择主将的时候，比如培养为攻击性，最好是X，0，0型，智力型最好是0，0，X

这样我们就可以在同样的星级获得更多的属性。

至于副将，只要他最高的成长属性是你需要的就OK。至于是几点，没有关系，如果不用结婚戒指，升级到70代，平均也就2-3点一次结婚。如果用呢，就可以少“繁衍N代”这点大家可以去观察你们区武将排名。就清楚了.

=end

require "./pet_level_exp_data.rb"   #加载等级与对应经验的数据
require "./pet_marrige_increase_data.rb"   #加载成长上限对应的成长范围
require "./pet_lingxing_requirement_data.rb"   #加载结婚主副伙伴星级需求数据


class Pet
 
  attr_accessor :name   # 伙伴名，玩家可以更改
  attr_accessor :sex    # 伙伴性别，在获得或者结婚诞生的时候，以相同概率随机选择   0:男， 1:女
  attr_accessor :version    # 伙伴世代，即结婚次数。整形。
  attr_accessor :level    # 伙伴等级，通过打怪等获得经验，经验对应等级。
  attr_accessor :exp    # 伙伴经验，经验对应等级。
  attr_accessor :former_max_level    # 伙伴前一代主伙伴结婚时的等级，后代能够顿悟，突然在某个级别达到此等级。
  attr_accessor :init_attack, :init_defend, :init_speed   #伙伴的初始攻击数值，初始防御数值,初始速度数值，浮点数。
  attr_accessor :cur_attack, :cur_defend, :cur_speed   #伙伴的当前攻击数值，当前防御数值,当前速度数值，浮点数。
  attr_accessor :increase_attack, :increase_defend, :increase_speed   #伙伴的攻击成长数值，防御成长数值,速度成长数值，浮点数。
  attr_accessor :star     #伙伴的星级。星级等于三种属性成长之和，除以10.0后取整。
        
  def initialize(name) #伙伴诞生，或许是结婚诞生的，哈哈。
 
     @name = name
 
     @sex = rand(2)       # 随机生成性别。
     @version =0   #第0代
     @level = 1    #初始的时候，等级为1
     @exp =0       #经验为0

     @init_attack=rand(100).to_f    #初始攻击力，为0-100随机,浮点数
     @init_defend=rand(100).to_f    #初始防御力，为0-100随机,浮点数
     @init_speed=rand(100).to_f     #初始速度，为0-100随机,浮点数

     # 诞生的时候，当前攻击、当前防御和当前速度，各自等于初始数值。
     @cur_attack=@init_attack
     @cur_defend=@init_defend
     @cur_speed=@init_speed
     # 诞生的时候，各个属性的成长数值，可以排列组合6种情况。
     # 属性成长数值的差异是伙伴差异的根本因素。
     generate_initial_increase_data
     
     # 诞生的时候，前世最高等级为0
     @former_max_level=0
     # 星级，星级等于三种属性成长之和，除以10后向上取整
     @star = ((@increase_attack+@increase_defend+@increase_speed)/10.0).ceil

  end 

  def who?
    return @name
  end
# 
#  产生初始的各个属性的成长数值，可以排列组合6种情况。属性成长数值的差异是伙伴差异的根本因素。
=begin
  具体类别： 
１、	攻防型伙伴：攻击成长最高、速度成长最低；
这类伙伴攻击最高，也有一定的防御，速度最低；
２、	防攻型伙伴：防御成长最高、速度成长最低；
这类伙伴防御最高，也有一定的攻击，速度最低；
３、	攻速型伙伴：攻击成长最高、防御成长最低；
这类伙伴攻击最高，也有一定的速度，防御最低；
４、	速攻型伙伴：速度成长最高、防御成长最低；
这类伙伴速度最高，也有一定的攻击，防御最低；
５、	防速型伙伴：防御成长最高、攻击成长最低；
这类伙伴防御最高，也有一定的速度，攻击最低；
６、	速防型伙伴：速度成长最高、攻击成长最低；
这类伙伴速度最高，也有一定的防御，攻击最低；

=end  
  def generate_initial_increase_data
     r=rand(6)
     case r
          when 0  # 攻防型伙伴：攻击成长最高、速度成长最低；
              @increase_attack=6+rand(5)
              @increase_defend=2+rand(4)
              @increase_speed=0
          when 1  #防攻型伙伴：防御成长最高、速度成长最低；
              @increase_attack=2+rand(4)
              @increase_defend=6+rand(5)
              @increase_speed=0

          when 2  #攻速型伙伴：攻击成长最高、防御成长最低；
              @increase_attack=6+rand(5)
              @increase_defend=0
              @increase_speed=2+rand(4)
          when 3  #速攻型伙伴：速度成长最高、防御成长最低；
              @increase_attack=2+rand(4)
              @increase_defend=0
              @increase_speed=6+rand(5)  
          when 4  #防速型伙伴：防御成长最高、攻击成长最低；
              @increase_attack=0
              @increase_defend=6+rand(5)         
              @increase_speed=2+rand(4)

          when 5 #	速防型伙伴：速度成长最高、攻击成长最低；
              @increase_attack=0         
              @increase_defend=2+rand(4)
              @increase_speed=6+rand(5)
     end

     @increase_attack=@increase_attack.to_f
     @increase_defend=@increase_defend.to_f
     @increase_speed=@increase_speed.to_f
     

  end


  # 查询当前经验对应多少等级，这是一个查表的过程。
  # 返回一个整数，就对应的等级。
  def level_for_current_exp
      
      0.upto(99) do |i|
          if @exp >$pet_level_exp[i][2].to_i and 
             @exp <$pet_level_exp[i+1][2].to_i then
            return i+1
          end 
                                
      end

    
  end

# 根据伙伴当前的属性增长数值，查询增长的上下限数值，返回的是一个数组，
# 数组中第一个是下限，第二个是上限，都是浮点数。
  def get_star_increase_range(current_attribute_increase_value)
   puts  "current_attribute_increase_value="+current_attribute_increase_value.to_s
   0.upto(25) do |i|
      puts i.to_s
      puts $pet_marrige_increase_data[i][0].to_f.to_s
      if current_attribute_increase_value >=$pet_marrige_increase_data[i][0].to_f and  current_attribute_increase_value <= $pet_marrige_increase_data[i+1][0].to_f then
      
      return  $pet_marrige_increase_data[i+1][1].to_f, $pet_marrige_increase_data[i+1][2].to_f
     
     end
    end
  end

  # 处理升级事宜,也就是当前的攻击力、防御力和速度，都增加了。增加的数值，分别等于各自的成长数值。
  def level_up
     # 当前属性数值，增加。增加的数值，是成长数值。
     @cur_attack += @increase_attack
     @cur_defend += @increase_defend
     @cur_speed  += @increase_speed
     # 等级增加
     @level +=1
     # 每次升级，都测试是否可以顿悟。
     dunwu 
  end

  # 伙伴和另一位伙伴结婚，自己“转世”了，也就是变成了自己的后代。在玩家看来，伙伴父母消失，诞生了一个新伙伴。
  # 输入参数：
  #   an_other_pet      结婚的副伙伴
  #   ring              玩家是否在伙伴结婚的时候使用皇后的祝福，如果用，则后代成长数值高。皇后的祝福是收费的，哈哈。
  def marriage( an_other_pet, ring=true)
  
   # 记住伙伴自己前世的最高等级，今后好顿悟哦。
   @former_max_level=@level
   #等级和经验都复原。
   @level=1
   @exp=0
   # 性别重新产生，等概率随机选择为男、女
   @sex = rand(2)
   # 世代增加了一。
   @version +=1
   # 名字也变了,反映世代的变化。
   @name =@name+@version.to_s
   

   #选择新的成长类型。
   # 规则是：副伙伴三种属性成长数值最高的那个属性，就会成为后代新的属性增长点，其他两个属性的增长数值还等于主伙伴的属性成长数值。
   # 例如，副伙伴的“攻击力成长”是三个数值中最高的，那么，诞生的后代伙伴中：
   #  1. 防御的成长数值和速度成长数值，仍然等于主伙伴的成长数值。
   #  2. 攻击力的成长，将增加。增加多少？基本规则是，当前成长高的，成长的增加就低，成长低的，成长的增加就高。具体数值，可查表格pet_marrige_increase_data.rb。
   
   #首先查副伙伴的三项属性成长中，哪个数值最大。
   max_increase=get_max_attribute_increase(an_other_pet)
   # 根据副伙伴最大属性成长，重新计算后代的属性成长数值。
   case  max_increase
       when  0  # 增加攻击力
             low, high=get_star_increase_range(@increase_attack)
             if ring==true then   # 如果有皇后的祝福，成长就取最大
                @increase_attack +=high
             else   #没有戒指，那么就在区间中随机取
                @increase_attack +=(low*1000.0+rand((high-low)*1000))/1000.0
            end
       when  1  # 增加防御力
              low, high=get_star_increase_range(@increase_defend)
             if ring==true then   # 如果有皇后的祝福，成长就取最大
             @increase_defend +=high
             else   #没有皇后之祝福，那么就在区间中随机取
             @increase_defend +=(low*1000.0+rand((high-low)*1000))/1000.0

             end    

       when  2  # 增加速度
             low, high=get_star_increase_range(@increase_speed)
             if ring==true then   # 如果有皇后的祝福，成长就取最大
             @increase_speed +=high
             else   #没有皇后之祝福，那么就在区间中随机取
             @increase_speed +=(low*1000.0+rand((high-low)*1000))/1000.0

             end      
            
   end 

   # 重新产生后代的初始属性数值
   # 规则：如果某属性，副伙伴的比主伙伴的高，那么，新的初始属性=主伙伴初始属性＋（副伙伴初始属性-主伙伴属性）/2
   #      如果某属性，副伙伴的比主伙伴的低，则直接只用主伙伴的。
   
     if @init_attack < an_other_pet.init_attack then
        @init_attack += (an_other_pet.init_attack-@init_attack)/2
     end
     if @init_defend < an_other_pet.init_defend then
        @init_defend += (an_other_pet.init_defend-@init_defend)/2
     end
     if @init_speed < an_other_pet.init_defend then
        @init_speed += (an_other_pet.init_defend-@init_defend)/2
     end

     # 诞生的时候，当前攻击、当前防御和当前速度，各自等于初始数值。
     @cur_attack=@init_attack
     @cur_defend=@init_defend
     @cur_speed=@init_speed
    

  end 

  # 顿悟
  # 条件：伙伴到了某个等级，例如50级, 并且小于前世最高等级，则一下子回忆起他前世的最高等级，这叫顿悟。
  # 效果：各种属性一直升到前世最高等级。
  def dunwu
    if @level==50 and @level < @former_max_level then
      
      # 持续升级,一直到前世的等级
      (@former_max_level-@level).times {level_up}
      # 经验相应地变成前世最高等级对应的经验。
      # 查表就可以了。
      @exp=$pet_level_exp[@former_max_level+1][2].to_i
    end
  end



  # 获取一个伙伴攻击、防御和速度三项成长数值最高的。
  # 如果攻击成长最高，则返回0
  # 如果防御成长最高，则返回1
  # 如果速度成长最高，则返回2

  def get_max_attribute_increase(an_other_pet)
    attribute_array=[]
    attribute_array <<  an_other_pet.increase_attack.to_f
    attribute_array <<  an_other_pet.increase_defend.to_f
    attribute_array <<  an_other_pet.increase_speed.to_f
    # 利用ruby 数组的max功能。
    max_a=attribute_array.max
    puts "hahaha!Max is #{max_a}"
    if max_a == an_other_pet.increase_attack.to_f
           puts "攻击最大"
           return 0
    elsif  max_a == an_other_pet.increase_defend.to_f
           puts "防御最大"
           return 1
    else
           puts "速度最大"
           return 2
    end

    
  end

  # 检查此伙伴是否能和另外一个伙伴结婚。条件：
=begin
１、	主伙伴可以是男的也可以是女的，但配偶的性别必须与主伙伴相反；
２、	主伙伴必须达到５０级；
３、	配偶必须达到２０级；
5、	主伙伴的星级越高，对配偶的星级的需求也越高，具体参看《星级需求》；
7       两个伙伴的星级还有限制关系。

点击“结婚”按钮时对上述条件进行检查，如有不符，则弹出相应的对话框进行提示。例如
“主伙伴和副伙伴必须是异性才能结婚。”
“主伙伴的等级不够，50级才能结婚。”
“副伙伴的等级不够，20级才能“副伙伴的等级不够，20级才能结婚”
“副伙伴星级不够，不能结婚。”


补充：
针对大明，要做下面的改进。

结婚时：
1.      男方(基因保底)：性别男、阉派。
        女方(基因拉优)：性别女，阉派。

２、	主伙伴必须达到５０级；
３、	配偶必须达到3０级；



=end
  
  def can_get_married? (an_other_pet)
    
     #条件一：性别相同不能结婚。 
     if @sex==an_other_pet.sex then
         puts "性别一样啊，咋结婚。"
         return false
     end
     #条件二：主伙伴必须达到５０级
     if @level<50 then
        puts "基因保持者等级不到50,咋结婚。"
        return false
     end
     #条件三：配偶必须达到２０级
     if an_other_pet.level<30 then
        puts "基因跳优者等级不到30,咋结婚。"
        return false
     end
     return true
     # 再检查星级
     #return false if 星级不匹配 
     
  end
  
end
