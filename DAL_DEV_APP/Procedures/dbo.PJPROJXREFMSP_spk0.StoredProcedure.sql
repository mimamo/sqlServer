USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJXREFMSP_spk0]    Script Date: 12/21/2015 13:35:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJXREFMSP_spk0] @parm1 varchar (16)  as
select Project_MSPID from PJPROJXREFMSP
where project    like @parm1
GO
