USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJUOPDET_sNotPost]    Script Date: 12/21/2015 14:17:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJUOPDET_sNotPost]  @parm1 varchar (16)   as
select PJUOPDET.* from PJUOPDET, PJTIMHDR
where
PJTIMHDR.docnbr = PJUOPDET.docnbr and
PJTIMHDR.th_status <> 'P' and
PJUOPDET.project     =  @parm1
GO
