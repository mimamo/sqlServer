USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJEXPTYP_SALL]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJEXPTYP_SALL]  @parm1 varchar (4)   as
select * from PJEXPTYP
where    exp_type Like @parm1
order by exp_type
GO
