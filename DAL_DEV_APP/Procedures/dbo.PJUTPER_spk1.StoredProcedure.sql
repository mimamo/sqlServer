USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJUTPER_spk1]    Script Date: 12/21/2015 13:35:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJUTPER_spk1] @parm1 varchar (6)  as
select * from PJUTPER
where   period <= @parm1
order by period DESC
GO
