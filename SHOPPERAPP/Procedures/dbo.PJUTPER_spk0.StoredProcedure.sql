USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJUTPER_spk0]    Script Date: 12/21/2015 16:13:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJUTPER_spk0] @parm1 varchar (6)  as
select * from PJUTPER
where   period = @parm1
	order by period
GO
