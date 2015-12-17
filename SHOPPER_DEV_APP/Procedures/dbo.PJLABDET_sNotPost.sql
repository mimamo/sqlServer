USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJLABDET_sNotPost]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJLABDET_sNotPost]  @parm1 varchar (16)   as
select PJLABDET.* from PJLABDET, PJLABHDR
where
PJLABDET.project     =  @parm1 and
PJLABHDR.docnbr = PJLABDET.docnbr and
PJLABHDR.le_status <> 'P' and
PJLABHDR.le_status <> 'X'
GO
