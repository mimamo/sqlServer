USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[earntype_spk0]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[earntype_spk0] @parm1 varchar (10)   as
select * from earntype
where id = @parm1
GO
