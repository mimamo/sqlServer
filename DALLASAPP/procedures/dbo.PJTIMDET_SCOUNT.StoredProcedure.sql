USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJTIMDET_SCOUNT]    Script Date: 12/21/2015 13:45:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJTIMDET_SCOUNT] @parm1 varchar (16)  as
select COUNT(*) from Pjtimdet
where
Pjtimdet.project = @parm1 and
Pjtimdet.tl_status <> 'P'
GO
