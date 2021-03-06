USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[x21KC_delete_pjrate]    Script Date: 12/21/2015 15:55:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21KC_delete_pjrate]  @key char(1),@ToRateValue varchar(32), @rate_table_id varchar(4), @rate_type_cd char(2), @rate_level varchar(1), @rate_key_value1 varchar(32), @rate_key_value2 varchar(32), @effect_date  smalldatetime  as
declare @numrecs int
select @numrecs = count(*) from pjrate where 
rate_table_id =@rate_table_id
and rate_type_cd = @rate_type_cd
and rate_level = @rate_level
and rate_key_value1 = 
	case when @key=1 then @ToRateValue
             else @rate_key_value1
        end
and rate_key_value2 = 
	case when @key=2 then @ToRateValue
	      else @rate_key_value2
         end
and effect_date = @effect_date
if @numrecs >0 
	Begin
	  delete from pjrate where rate_table_id =@rate_table_id 
	  and rate_type_cd = @rate_type_cd 
	  and rate_level = @rate_level
          and  rate_key_value1 = @rate_key_value1
	  and rate_key_value2 = @rate_key_value2
	  and effect_date = @effect_date
	end
GO
