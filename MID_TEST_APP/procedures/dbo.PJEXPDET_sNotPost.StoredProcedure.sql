USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJEXPDET_sNotPost]    Script Date: 12/21/2015 15:49:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJEXPDET_sNotPost]  @parm1 varchar (16)   as
select PJEXPDET.* from PJEXPDET, PJEXPHDR
where
PJEXPHDR.docnbr = PJEXPDET.docnbr and
PJEXPHDR.status_1 <> 'P' and
PJEXPDET.project     =  @parm1
GO
