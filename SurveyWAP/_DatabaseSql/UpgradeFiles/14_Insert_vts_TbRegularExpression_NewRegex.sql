USE [DBNAME]
GO
SET IDENTITY_INSERT [dbo].[vts_tbRegularExpression] ON 
GO
INSERT [dbo].[vts_tbRegularExpression] ([RegularExpressionId], [Description], [RegExpression], [RegExMessage], [BuiltIn]) VALUES (6, N'Hours', N'^([0-9]|[1][0-9]|[2][0-4])$', N'0 - 24 hours only', 1)
GO
INSERT [dbo].[vts_tbRegularExpression] ([RegularExpressionId], [Description], [RegExpression], [RegExMessage], [BuiltIn]) VALUES (7, N'Minutes', N'^([0-9]|[1-4][0-9]|[5][0-9])$', N'0 - 59 minutes allowed', 1)
GO
INSERT [dbo].[vts_tbRegularExpression] ([RegularExpressionId], [Description], [RegExpression], [RegExMessage], [BuiltIn]) VALUES (8, N'WeekDays', N'^([0-7])$', N'0 - 7 days allowed', 1)
GO
SET IDENTITY_INSERT [dbo].[vts_tbRegularExpression] OFF
GO
