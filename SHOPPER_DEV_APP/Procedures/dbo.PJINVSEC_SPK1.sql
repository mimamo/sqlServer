USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJINVSEC_SPK1]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJINVSEC_SPK1] @parm1 varchar (4)   as
select * from PJINVSEC
where inv_format_cd = @parm1
order by acct
GO
