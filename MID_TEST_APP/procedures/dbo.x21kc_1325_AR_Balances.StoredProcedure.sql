USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[x21kc_1325_AR_Balances]    Script Date: 12/21/2015 15:49:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21kc_1325_AR_Balances]  @cpnyid varchar(10), @custid varchar(15) as
select * from AR_Balances where 
cpnyid = @cpnyid
and custid = @custid
order by cpnyid
GO
