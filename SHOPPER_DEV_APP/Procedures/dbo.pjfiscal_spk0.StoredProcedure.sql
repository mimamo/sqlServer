USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjfiscal_spk0]    Script Date: 12/21/2015 14:34:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[pjfiscal_spk0] @parm1 varchar (6)  as
select * from pjfiscal
where   fiscalno = @parm1
	order by fiscalno
GO
