USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[x21kc_1325_SlsTaxHist]    Script Date: 12/21/2015 13:57:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21kc_1325_SlsTaxHist]  @cpnyid varchar(10), @taxid varchar(10), @yrmon varchar(6) as
select * from SlsTaxHist where 
cpnyid = @cpnyid
and taxid = @taxid
and yrmon = @yrmon
order by cpnyid
GO
