USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJEMPLOYXREFMSP_spk0]    Script Date: 12/21/2015 13:57:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJEMPLOYXREFMSP_spk0] @parm1 varchar (10)  as
select * from PJEMPLOYXREFMSP
where Employee    like @parm1
GO
