USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[earntype_spk0]    Script Date: 12/21/2015 16:07:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[earntype_spk0] @parm1 varchar (10)   as
select * from earntype
where id = @parm1
GO
