USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[x21kc_1325_AP_Balances]    Script Date: 12/21/2015 15:43:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21kc_1325_AP_Balances]  @cpnyid varchar(10), @vendid varchar(15) as
select * from AP_Balances where 
cpnyid = @cpnyid
and vendid = @vendid
order by cpnyid
GO
