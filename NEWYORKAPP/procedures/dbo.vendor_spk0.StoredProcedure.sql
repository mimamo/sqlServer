USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[vendor_spk0]    Script Date: 12/21/2015 16:01:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[vendor_spk0] @parm1 varchar (15)  as
select * from  vendor
where vendid = @parm1
order by vendid
GO
