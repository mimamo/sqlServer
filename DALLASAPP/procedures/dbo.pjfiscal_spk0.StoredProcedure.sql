USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[pjfiscal_spk0]    Script Date: 12/21/2015 13:44:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[pjfiscal_spk0] @parm1 varchar (6)  as
select * from pjfiscal
where   fiscalno = @parm1
	order by fiscalno
GO
