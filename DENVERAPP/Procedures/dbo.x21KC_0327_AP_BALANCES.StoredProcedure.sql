USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[x21KC_0327_AP_BALANCES]    Script Date: 12/21/2015 15:43:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21KC_0327_AP_BALANCES]  @vendid varchar(15), @cpnyid varchar(10)  as      
select * from ap_balances where 
vendid = @vendid
and cpnyid = @cpnyid
order by vendid
GO
