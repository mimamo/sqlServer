USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJADDR_SEQUAL]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJADDR_SEQUAL]  @parm1 varchar (2) , @parm2 varchar (48) , @parm3 varchar (2)   as
select * from PJADDR
where    addr_key_cd       = @parm1 and
addr_key     = @parm2 and
addr_type_cd = @parm3
order by addr_key_cd, addr_key,
addr_type_cd
GO
