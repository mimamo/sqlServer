USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[refnbr_spk0]    Script Date: 12/21/2015 14:17:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[refnbr_spk0] @parm1 varchar (10) as
select * from refnbr
where RefNbr = @parm1
order by RefNbr
GO
