USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[x21KC_SQMEQ_EQHist]    Script Date: 12/21/2015 13:45:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21KC_SQMEQ_EQHist] @equipid varchar(10), @calyear varchar(4) as
select  * from smEQHistory where
equipid = @equipid
and calyear = @calyear
order by equipid, calyear
GO
