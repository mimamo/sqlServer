USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[x21KC_PCPR_Pjactsum]    Script Date: 12/21/2015 15:55:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21KC_PCPR_Pjactsum]  @project varchar(16),  @fsyear_num varchar(4), @pjt_entity varchar(32), @acct varchar(16) as      
select * from pjactsum where 
project = @project
and  fsyear_num = @fsyear_num
and pjt_entity = @pjt_entity
and acct = @acct
order by project
GO
