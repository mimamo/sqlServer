USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[x21kc_1325_ARHist]    Script Date: 12/21/2015 14:18:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21kc_1325_ARHist]  @cpnyid varchar(10), @Custid varchar(15), @fiscyr varchar(4) as
select * from ARHist where 
cpnyid = @cpnyid
and Custid = @Custid
and fiscyr = @fiscyr
order by cpnyid
GO
