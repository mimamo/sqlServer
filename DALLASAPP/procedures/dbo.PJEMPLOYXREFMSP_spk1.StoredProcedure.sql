USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJEMPLOYXREFMSP_spk1]    Script Date: 12/21/2015 13:44:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJEMPLOYXREFMSP_spk1] @parm1 varchar (60)  as
select * from PJEMPLOYXREFMSP
where Employee_MSPName    like @parm1
GO
