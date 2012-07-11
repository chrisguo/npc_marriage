# -*- coding: utf-8 -*-
=begin

宠物系统。
规则都在代码之中了。

=end

require "pet_level_exp_data.rb"   #加载玩家等级与对应经验的数据
require "pet_marrige_increase_data.rb"   #加载玩家成长上限对应的成长范围
require "pet_lingxing_requirement_data.rb"   #加载结婚主副宠物星级需求数据


class Pet
 
  attr_accessor :name   # 宠物名，玩家可以更改
  attr_accessor :sex    # 宠物性别，在获得或者结婚诞生的时候，以相同概率随机选择   0:男， 1:女
  attr_accessor :version    # 宠物世代，即结婚次数。整形。
  attr_accessor :level    # 宠物等级，通过参与PK, 参与竞技场PK等获得经验，经验对应等级。
  attr_accessor :exp    # 宠物经验，通过参与PK, 参与竞技场PK等获得经验，经验对应等级。
  attr_accessor :former_max_level    # 宠物前一代主宠物结婚时的等级，后代能够顿悟，突然在某个级别达到此等级。
  attr_accessor :mode    # 宠物的情绪, 有“愉快”、“平和”、“郁闷”、“孤独”、“暴怒”几种。
  attr_accessor :init_attack, :init_defend, :init_speed   #宠物的初始攻击数值，初始防御数值,初始速度数值，浮点数。
  attr_accessor :cur_attack, :cur_defend, :cur_speed   #宠物的当前攻击数值，当前防御数值,当前速度数值，浮点数。
  attr_accessor :increase_attack, :increase_defend, :increase_speed   #宠物的攻击成长数值，防御成长数值,速度成长数值，浮点数。
  attr_accessor :star #宠物的星级。星级等于三种属性成长之和，除以10.0后取整。
  attr_accessor :qinmidu  #宠物与主人的亲密程度。初始数值都为70, 如果主人一天不喂食，亲密度下降1点，喂食则上升1点，让它参与战斗并
                          #赢了，则上升1点，让它参与竞技场比赛，上升1点，比赛赢了，则上升两点。
        
  def initialize(name) #或者是系统赠送的，或者是孵化的
 
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
     # 诞生的时候，各个属性的成长数值，可以排列组合6种情况。属性成长数值的差异是宠物差异的根本因素。
     generate_initial_increase_data
     
     # 诞生的时候，前世最高等级为0
     @former_max_level=0
     # 星级，星级等于三种属性成长之和，除以10后向上取整
     @star = ((@increase_attack+@increase_defend+@increase_speed)/10.0).ceil
     # 诞生的时候，和玩家的亲密度是70
     @qinmidu = 70
     # 诞生的时候，情绪很好
     @mode = "愉快"

  end 

  def who?
    return @name
  end
# 
#  产生各个属性的成长数值，可以排列组合6种情况。属性成长数值的差异是宠物差异的根本因素。
=begin
  具体类别： 
１、	攻防型宠物：攻击成长最高、速度成长最低；
这类宠物攻击最高，也有一定的防御，速度最低；
２、	防攻型宠物：防御成长最高、速度成长最低；
这类宠物防御最高，也有一定的攻击，速度最低；
３、	攻速型宠物：攻击成长最高、防御成长最低；
这类宠物攻击最高，也有一定的速度，防御最低；
４、	速攻型宠物：速度成长最高、防御成长最低；
这类宠物速度最高，也有一定的攻击，防御最低；
５、	防速型宠物：防御成长最高、攻击成长最低；
这类宠物防御最高，也有一定的速度，攻击最低；
６、	速防型宠物：速度成长最高、攻击成长最低；
这类宠物速度最高，也有一定的防御，攻击最低；

=end  
  def generate_initial_increase_data
     r=rand(6)
     case r
          when 0  # 攻防型宠物：攻击成长最高、速度成长最低；
              @increase_attack=6+rand(5)
              @increase_defend=2+rand(4)
              @increase_speed=0
          when 1  #防攻型宠物：防御成长最高、速度成长最低；
              @increase_attack=2+rand(4)
              @increase_defend=6+rand(5)
              @increase_speed=0

          when 2  #攻速型宠物：攻击成长最高、防御成长最低；
              @increase_attack=6+rand(5)
              @increase_defend=0
              @increase_speed=2+rand(4)
          when 3  #速攻型宠物：速度成长最高、防御成长最低；
              @increase_attack=2+rand(4)
              @increase_defend=0
              @increase_speed=6+rand(5)  
          when 4  #防速型宠物：防御成长最高、攻击成长最低；
              @increase_attack=0
              @increase_defend=6+rand(5)         
              @increase_speed=2+rand(4)

          when 5 #	速防型宠物：速度成长最高、攻击成长最低；
              @increase_attack=0         
              @increase_defend=2+rand(4)
              @increase_speed=6+rand(5)
     end
      @increase_attack=@increase_attack.to_f
      @increase_defend=@increase_defend.to_f
      @increase_speed=@increase_speed.to_f
     

  end


  #查询当前经验对应多少等级，这是一个查表的过程。
  # 返回一个整数，就对应的等级。
  def level_for_current_exp
      
      0.upto(99) do |i|
          if @exp >$pet_level_exp[i][2].to_i and 
             @exp <$pet_level_exp[i+1][2].to_i then
            return i+1
          end 
                                
      end

    
  end

# 根据当前某一个属性的成长数值，查询增长的上下限数值，返回的是一个数组，
# 数组中第一个是下限，第二个是上限，都是浮点数。
  def get_star_increase_range(current_increase_value)
    0.upto(25) do |i|
      if current_increase_value >$pet_marrige_increase_data[i][0].to_f and  current_increase_value <$pet_marrige_increase_data[i+1][0].to_f then
      
      return  $pet_marrige_increase_data[i+1][1].to_f, $pet_marrige_increase_data[i+1][2].to_f
     
     end
    end
  end

  # 参与玩家之间的PK, 如果主人赢了，那么对手法宝攻击力和防御力之和，将成为宠物从战斗中获得的经验值。
  # 如果主人输了，则无法获得经验。
  def fight(op_sum_attack_defend, win=true)  
    return if win == false  # 如果主人输了，则无法获得经验。
    # 如果赢了，那么就有经验增加，以及升级检查。
    # 把战斗经验加上 
    @exp = @exp + op_sum_attack_defend
    # 查是否升级了
    # 如果当前等级，小于当前经验对应的等级，那么就立刻升级到对应等级
    if @level< level_for_current_exp
       #处理升级事宜。
       level_up
    end 
    # 亲密度增加
    @qinmidu +=1
    @qinmidu =100 if @qinmidu >100
  end  

  # 处理升级事宜,也就是当前的攻击力、防御力和速度，都增加了。增加的数值，分别等于各自的成长数值。
  def level_up
     @cur_attack += @increase_attack
     @cur_defend += @increase_defend
     @cur_speed  += @increase_speed
     # 等级增加
     @level +=1
     # 每次升级，都测试是否可以顿悟。
     dunwu 
     # 情绪很好
     @mode = "愉快"
  end

  # 和另一位宠物结婚，自己“转世”了，也就是变成了自己的后代。在玩家看来，宠物父母消失，诞生了一个新宠物。
  # 输入参数：
  #   an_other_pet      结婚的副宠
  #   ring              玩家是否在宠物结婚的时候使用结婚戒指，如果用，则后代成长数值高。结婚戒指是收费道具。
  def marriage( an_other_pet, ring=true)
  
   # 记住前世的最高等级，好顿悟。
   @former_max_level=@level
   #等级和经验都复原。
   @level=1
   @exp=0
   # 性别重新产生，等概率为男、女
   @sex = rand(2)
   # 世代增加了一。
   @version +=1
   # 名字也变了,反映世代的变化。
   @name =@name+@version.to_s
   

   #选择新的成长类型。
   # 规则是：副宠物三种属性成长数值最高的那个属性，就会成为后代新的属性增长点，其他两个属性的增长数值还等于主宠的属性成长数值。
   # 例如，副宠的“攻击力成长”是三个数值中最高的，那么，诞生的后代宠物中：
   #  1. 防御的成长数值和速度成长数值，仍然等于主宠的成长数值。
   #  2. 攻击力的成长，将增加。增加多少？基本规则是，当前成长高的，成长的增加就低，成长低的，成长的增加就高。具体数值，可查表格pet_marrige_increase_data.rb。
   
   #首先查副宠物的三项属性成长中，哪个数值最大。
   max_increase=get_max_attribute_increase(an_other_pet)

   case  max_increase
       when  0  # 增加攻击力
             low, high=get_star_increase_range(@increase_attack)
             if ring==true then   # 如果有结婚戒指，成长就取最大
                @increase_attack +=high
             else   #没有戒指，那么就在区间中随机取
                @increase_attack +=(low*1000.0+rand((high-low)*1000))/1000.0
            end
       when  1  # 增加防御力
              low, high=get_star_increase_range(@increase_defend)
             if ring==true then   # 如果有结婚戒指，成长就取最大
             @increase_defend +=high
             else   #没有戒指，那么就在区间中随机取
             @increase_defend +=(low*1000.0+rand((high-low)*1000))/1000.0

             end    

       when  2  # 增加速度
             low, high=get_star_increase_range(@increase_speed)
             if ring==true then   # 如果有结婚戒指，成长就取最大
             @increase_speed +=high
             else   #没有戒指，那么就在区间中随机取
             @increase_speed +=(low*1000.0+rand((high-low)*1000))/1000.0

             end      
            
   end 

   # 重新产生后代的初始属性数值
   # 规则：如果某属性，副宠的比主宠的高，那么，新的初始属性=主宠物初始属性＋（副宠物初始属性-主宠属性）/2
   #      如果某属性，副宠的比主宠的低，则直接只用主宠的。
   
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
     # 新诞生的宠物情绪很好
     @mode = "愉快"    

  end 

  # 顿悟
  # 条件：宠物到了某个等级，例如50级, 并且小于前世最高等级，则一下子回忆起他前世的最高等级，这叫顿悟。
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



  # 给宠物喂食,会增加宠物的亲密度
  def give_food
     
     @qinmidu +=1
     @qinmidu =100 if @qinmidu >100
  end


  # 获取一个宠物攻击、防御和速度三项成长数值最高的。
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
    if max_a == an_other_pet.increase_attack.to_f
           return 0
    elsif  max_a == an_other_pet.increase_defend.to_f
           return 1
    else
           return 2
    end

    
  end

  # 检查此宠物是否能和另外一个宠物结婚。条件：
=begin
１、	主宠可以是男的也可以是女的，但配偶的性别必须与主宠相反；
２、	主宠必须达到５０级；
３、	配偶必须达到２０级；
4、	双方与主人的亲密度都必须为100；
5、	主宠的星级越高，对配偶的星级的需求也越高，具体参看《星级需求》；
6、	两个宠物都必须处于空闲状态，出战、死亡、摆摊等状态中的宠物均不可进行婚礼。
7       两个宠物的星级还有限制关系。

点击“结婚”按钮时对上述条件进行检查，如有不符，则弹出相应的对话框进行提示。例如
“主宠和副宠必须是异性才能结婚。”
“主宠的等级不够，50级才能结婚。”
“副宠的等级不够，20级才能“副宠的等级不够，20级才能结婚”
“宠物与主人的亲密度为100的时候才能结婚。”
“副宠物星级不够，不能结婚。”

=end
  
  def can_get_married? (an_other_pet)
    
     #条件一：性别相同不能结婚。 
     if @sex==an_other_pet.sex then
         return false
     end
     #条件二：主宠必须达到５０级
     if @level<50 then
        return false
     end
     #条件三：配偶必须达到２０级
     if an_other_pet.level<20 then
        return false
     end
     #条件四：双方与主人的亲密度都必须为100 
     if @qinmidu< 100 or an_other_pet.qinmidu< 100 then
        return false
     end
     # 再检查星级
     return false if 星级不匹配 
     
  end
  
end
