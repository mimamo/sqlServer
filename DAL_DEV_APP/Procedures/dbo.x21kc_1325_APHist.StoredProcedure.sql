USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[x21kc_1325_APHist]    Script Date: 12/21/2015 13:35:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21kc_1325_APHist]  @cpnyid varchar(10), @vendid varchar(15), @fiscyr varchar(4) as
select * from APHist where 
cpnyid = @cpnyid
and vendid = @vendid
and fiscyr = @fiscyr
order by cpnyid
GO
