USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJTIMDET_SCOUNT]    Script Date: 12/21/2015 14:06:14 ******/
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
