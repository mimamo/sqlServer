USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJINVSEC_SPK1]    Script Date: 12/21/2015 16:13:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJINVSEC_SPK1] @parm1 varchar (4)   as
select * from PJINVSEC
where inv_format_cd = @parm1
order by acct
GO
