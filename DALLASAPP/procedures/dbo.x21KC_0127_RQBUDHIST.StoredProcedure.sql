USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[x21KC_0127_RQBUDHIST]    Script Date: 12/21/2015 13:45:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21KC_0127_RQBUDHIST]  @sub varchar(24), @acct varchar(10),@ledgerid varchar(10), @fiscyr varchar(4), @user5 varchar(10) as      
select * from rqbudhist where 
sub = @sub
and acct = @acct
and ledgerid = @ledgerid
and fiscyr = @fiscyr
and user5 = @user5
order by sub
GO
