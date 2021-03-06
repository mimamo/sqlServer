USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pp_01520_autoload]    Script Date: 12/21/2015 15:49:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[pp_01520_autoload] @useraddress char(21)

WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as
insert into wrkpost
select w.batnbr,w.module,useraddress,null
          from wrkrelease w,batch b
         where useraddress = @useraddress
           and w.module = b.module
           and w.batnbr = b.batnbr
           and b.PerPost <= (SELECT PerNbr FROM GLSetup)
GO
