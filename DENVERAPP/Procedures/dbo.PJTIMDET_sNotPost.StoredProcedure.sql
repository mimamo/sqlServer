USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJTIMDET_sNotPost]    Script Date: 12/21/2015 15:43:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJTIMDET_sNotPost]  @parm1 varchar (16)   as
select PJTIMDET.* from PJTIMDET, PJTIMHDR
where
PJTIMHDR.docnbr = PJTIMDET.docnbr and
PJTIMHDR.th_status <> 'P' and
PJTIMDET.project     =  @parm1
GO
