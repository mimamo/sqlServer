USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[xkcSoAddr_duplicate]    Script Date: 12/21/2015 13:45:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xkcSoAddr_duplicate] @custid varchar(15), @shiptoid varchar(10) as
select count (*) from soaddress where
custid = @custid
and shiptoid = @shiptoid
GO
