USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJUTPER_spk1]    Script Date: 12/21/2015 15:43:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJUTPER_spk1] @parm1 varchar (6)  as
select * from PJUTPER
where   period <= @parm1
order by period DESC
GO
