USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[vendor_spk9]    Script Date: 12/21/2015 13:57:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[vendor_spk9] @parm1 varchar (250) , @parm2 varchar (15)  as
select * from  vendor
where vendid = @parm2
order by vendid
GO
