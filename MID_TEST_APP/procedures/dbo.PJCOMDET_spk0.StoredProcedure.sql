USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJCOMDET_spk0]    Script Date: 12/21/2015 15:49:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCOMDET_spk0] @parm1 varchar (2)   as
select * from PJCOMDET
where    system_cd like @parm1
GO
