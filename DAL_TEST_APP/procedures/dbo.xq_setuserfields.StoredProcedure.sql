USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xq_setuserfields]    Script Date: 12/21/2015 13:57:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create      
 proc      
 [dbo].[xq_setuserfields]      
(      
 @draft_num char(10),       
     
 @user1 char(250),       
 @user2 char(250),        
 @user3 char(250),        
 @user4 char(250),        
 @user5 char(250),       
 @user6 char(250),       
 @user7 char(250),        
 @user8 char(250),        
 @user9 char(250),        
 @user10 char(250)        
     
 ,@user11 char(250),       
 @user12 char(250),        
 @user13 char(250),        
 @user14 char(250),        
 @user15 char(250),       
 @user16 char(250),       
 @user17 char(250),        
 @user18 char(250),        
 @user19 char(250),        
 @user20 char(250)        
     
    
 ,@user21 char(250),       
 @user22 char(250),        
 @user23 char(250),        
 @user24 char(250),        
 @user25 char(250),       
 @user26 char(250),       
 @user27 char(250),        
 @user28 char(250),        
 @user29 char(250),        
 @user30 char(250)        
     
  
  
 ,@user31 char(350),       
 @user32 char(350),        
 @user33 char(350),        
 @user34 char(350),        
 @user35 char(350),       
 @user36 char(350),       
 @user37 char(350),        
 @user38 char(350),        
 @user39 char(350),        
 @user40 char(350)        
  
  
 ,@user41 char(450),       
 @user42 char(450),        
 @user43 char(450),        
 @user44 char(450),        
 @user45 char(450),       
 @user46 char(450),       
 @user47 char(450),        
 @user48 char(450),        
 @user49 char(450),        
 @user50 char(450)        
  
  
  
)      
       
as      
      
declare @c int      
      
set @c      
=      
(      
select       
 count(*)      
from      
  xqpjinvhdr      
where      
 draft_num=rtrim(ltrim(@draft_num))       
)      
      
if @c=0      
   begin      
  insert into      
   xqpjinvhdr       
   (      
draft_num ,       
 user1 ,       
 user2 ,        
 user3 ,        
 user4 ,        
 user5 ,       
 user6 ,       
 user7 ,        
 user8 ,        
 user9 ,        
 user10      
 ,user11 ,       
 user12 ,        
 user13 ,        
 user14 ,        
 user15 ,       
 user16 ,       
 user17 ,        
 user18 ,        
 user19 ,        
 user20          
     
 ,user21 ,       
 user22 ,        
 user23 ,        
 user24 ,        
 user25 ,       
 user26 ,       
 user27 ,        
 user28 ,        
 user29 ,        
 user30          
    
  
 ,user31 ,       
 user32 ,        
 user33 ,        
 user34 ,        
 user35 ,       
 user36 ,       
 user37 ,        
 user38 ,        
 user39 ,        
 user40          
    
,user41 ,       
 user42 ,        
 user43 ,        
 user44 ,        
 user45 ,       
 user46 ,       
 user47 ,        
 user48 ,        
 user49 ,        
 user50          
        
  
        
  )      
   values      
   (      
 rtrim(ltrim(@draft_num)) ,      
    
 rtrim(ltrim(@user1)) ,       
 rtrim(ltrim(@user2)) ,        
 rtrim(ltrim(@user3)) ,        
 rtrim(ltrim(@user4)) ,        
 rtrim(ltrim(@user5)) ,       
 rtrim(ltrim(@user6)) ,       
 rtrim(ltrim(@user7)) ,        
 rtrim(ltrim(@user8)) ,        
 rtrim(ltrim(@user9)) ,        
 rtrim(ltrim(@user10))       
    
    
,rtrim(ltrim(@user11)) ,       
 rtrim(ltrim(@user12)) ,        
 rtrim(ltrim(@user13)) ,        
 rtrim(ltrim(@user14)) ,        
 rtrim(ltrim(@user15)) ,       
 rtrim(ltrim(@user16)) ,       
 rtrim(ltrim(@user17)) ,        
 rtrim(ltrim(@user18)) ,        
 rtrim(ltrim(@user19)) ,        
 rtrim(ltrim(@user20))        
    
,rtrim(ltrim(@user21)) ,       
 rtrim(ltrim(@user22)) ,        
 rtrim(ltrim(@user23)) ,        
 rtrim(ltrim(@user24)) ,        
 rtrim(ltrim(@user25)) ,       
 rtrim(ltrim(@user26)) ,       
 rtrim(ltrim(@user27)) ,        
 rtrim(ltrim(@user28)) ,        
 rtrim(ltrim(@user29)) ,        
 rtrim(ltrim(@user30))       
  
  
,rtrim(ltrim(@user31)) ,       
 rtrim(ltrim(@user32)) ,        
 rtrim(ltrim(@user33)) ,        
 rtrim(ltrim(@user34)) ,        
 rtrim(ltrim(@user35)) ,       
 rtrim(ltrim(@user36)) ,       
 rtrim(ltrim(@user37)) ,        
 rtrim(ltrim(@user38)) ,        
 rtrim(ltrim(@user39)) ,        
 rtrim(ltrim(@user40))       
  
   
 ,rtrim(ltrim(@user41)) ,       
 rtrim(ltrim(@user42)) ,        
 rtrim(ltrim(@user44)) ,        
 rtrim(ltrim(@user44)) ,        
 rtrim(ltrim(@user45)) ,       
 rtrim(ltrim(@user46)) ,       
 rtrim(ltrim(@user47)) ,        
 rtrim(ltrim(@user48)) ,        
 rtrim(ltrim(@user49)) ,        
 rtrim(ltrim(@user50))    
   
     
  )      
  end     
     
 else      
  begin      
   update      
    xqpjinvhdr       
   set      
    user1=rtrim(ltrim(@user1)) ,       
user2= rtrim(ltrim(@user2)) ,        
user3=  rtrim(ltrim(@user3)) ,        
user4=  rtrim(ltrim(@user4)) ,        
user5=  rtrim(ltrim(@user5)) ,       
user6=  rtrim(ltrim(@user6)) ,       
user7=  rtrim(ltrim(@user7)) ,        
user8=  rtrim(ltrim(@user8)) ,        
user9=  rtrim(ltrim(@user9)) ,        
user10=  rtrim(ltrim(@user10))        
     
,user11=rtrim(ltrim(@user11)) ,       
user12= rtrim(ltrim(@user12)) ,        
user13=  rtrim(ltrim(@user13)) ,        
user14=  rtrim(ltrim(@user14)) ,        
user15=  rtrim(ltrim(@user15)) ,       
user16=  rtrim(ltrim(@user16)) ,       
user17=  rtrim(ltrim(@user17)) ,        
user18=  rtrim(ltrim(@user18)) ,        
user19=  rtrim(ltrim(@user19)) ,        
user20=  rtrim(ltrim(@user20))        
    
,user21=rtrim(ltrim(@user21)) ,       
user22= rtrim(ltrim(@user22)) ,        
user23=  rtrim(ltrim(@user23)) ,        
user24=  rtrim(ltrim(@user24)) ,        
user25=  rtrim(ltrim(@user25)) ,       
user26=  rtrim(ltrim(@user26)) ,       
user27=  rtrim(ltrim(@user27)) ,        
user28=  rtrim(ltrim(@user28)) ,        
user29=  rtrim(ltrim(@user29)) ,        
user30=  rtrim(ltrim(@user30))        
    
  
,user31=rtrim(ltrim(@user31)) ,       
user32= rtrim(ltrim(@user32)) ,        
user33=  rtrim(ltrim(@user33)) ,        
user34=  rtrim(ltrim(@user34)) ,        
user35=  rtrim(ltrim(@user35)) ,       
user36=  rtrim(ltrim(@user36)) ,       
user37=  rtrim(ltrim(@user37)) ,        
user38=  rtrim(ltrim(@user38)) ,        
user39=  rtrim(ltrim(@user39)) ,        
user40=  rtrim(ltrim(@user40))          
  
  
,user41=rtrim(ltrim(@user41)) ,       
user42= rtrim(ltrim(@user42)) ,        
user43=  rtrim(ltrim(@user43)) ,        
user44=  rtrim(ltrim(@user44)) ,        
user45=  rtrim(ltrim(@user45)) ,       
user46=  rtrim(ltrim(@user46)) ,       
user47=  rtrim(ltrim(@user47)) ,        
user48=  rtrim(ltrim(@user48)) ,        
user49=  rtrim(ltrim(@user49)) ,        
user50=  rtrim(ltrim(@user50))          
      
  
   where      
    draft_num=rtrim(ltrim(@draft_num))     
  end
GO
