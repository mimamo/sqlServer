USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[x21KC_0126_RQBUDHIST]    Script Date: 12/21/2015 15:43:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21KC_0126_RQBUDHIST]  @acct varchar(10),@sub varchar(24), @ledgerid varchar(10), @fiscyr varchar(4), @user5 varchar(10) as      
select * from rqbudhist where 
acct = @acct
and sub = @sub
and ledgerid = @ledgerid
and fiscyr = @fiscyr
and user5 = @user5
order by acct
GO
