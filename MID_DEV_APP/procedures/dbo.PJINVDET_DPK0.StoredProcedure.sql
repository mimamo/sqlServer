USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJINVDET_DPK0]    Script Date: 12/21/2015 14:17:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[PJINVDET_DPK0]  @parm1 varchar (10)   as
Delete from PJINVDET
where draft_num = @parm1
and li_type   = 'S'
GO
