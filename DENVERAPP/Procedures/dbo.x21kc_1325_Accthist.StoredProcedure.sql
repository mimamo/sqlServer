USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[x21kc_1325_Accthist]    Script Date: 12/21/2015 15:43:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21kc_1325_Accthist]  @cpnyid varchar(10), @acct varchar(10), @sub varchar(24), @ledgerid varchar(10), @fiscyr varchar(4) as   
select * from accthist where 
cpnyid = @cpnyid
and acct = @acct
and sub = @sub
and ledgerid = @ledgerid
and fiscyr = @fiscyr
order by cpnyid
GO
