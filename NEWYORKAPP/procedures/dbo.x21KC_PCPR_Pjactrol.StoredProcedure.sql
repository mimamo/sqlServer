USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[x21KC_PCPR_Pjactrol]    Script Date: 12/21/2015 16:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21KC_PCPR_Pjactrol]  @project varchar(16),@fsyear_num varchar(4), @acct varchar(16) as      
select * from pjactrol where 
project = @project
and fsyear_num = @fsyear_num
and acct = @acct
order by project
GO
