USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJINVSEC_DPK0]    Script Date: 12/21/2015 13:45:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJINVSEC_DPK0]  @parm1 varchar (4) as
delete from PJINVSEC
where inv_format_cd = @parm1
GO
