USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[xqLaborClasses]    Script Date: 12/21/2015 13:56:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[xqLaborClasses] 
as 
select * from pjcode where code_type = 'labc'
GO
