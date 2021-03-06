USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJEXPDET_SAMT]    Script Date: 12/21/2015 14:17:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/******Modified to retrieve total exp report total as well as emp paid amt. BK 09/28/05 ******/
create procedure [dbo].[PJEXPDET_SAMT]  @parm1 varchar (10)   as
select
sum(pjexpdet.amt_employ), sum(pjexpdet.amt_employ) + sum(pjexpdet.amt_company)
FROM  pjexpdet
where    docnbr     =  @parm1
GO
